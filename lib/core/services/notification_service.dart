import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');
  debugPrint('Message notification: ${message.notification?.title}');
}

/// Service for handling push notifications via Firebase Cloud Messaging
@lazySingleton
class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final Dio _dio;

  NotificationService(
    this._firebaseMessaging,
    this._localNotifications,
    this._dio,
  );

  /// Stream controller for notification taps
  final StreamController<Map<String, dynamic>> _notificationTapController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of notification taps (for deep linking)
  Stream<Map<String, dynamic>> get onNotificationTap =>
      _notificationTapController.stream;

  /// Initialize notification service
  Future<void> initialize() async {
    try {
      // Request notification permissions (iOS)
      await _requestPermissions();

      // Configure Firebase Messaging
      await _configureFirebaseMessaging();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token and register device
      await _registerDevice();

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen(_onTokenRefresh);

      debugPrint('NotificationService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      rethrow;
    }
  }

  /// Request notification permissions (iOS)
  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('Notification permission status: ${settings.authorizationStatus}');
    }
  }

  /// Configure Firebase Messaging handlers
  Future<void> _configureFirebaseMessaging() async {
    // Set foreground notification presentation options (iOS)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check for initial message (app opened from terminated state)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize plugin
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
        if (details.payload != null) {
          final data = _parsePayload(details.payload!);
          _notificationTapController.add(data);
        }
      },
    );

    debugPrint('Local notifications initialized');
  }

  /// Register device with backend
  Future<void> _registerDevice() async {
    try {
      // Get FCM token
      final token = await _firebaseMessaging.getToken();
      if (token == null) {
        debugPrint('Failed to get FCM token');
        return;
      }

      debugPrint('FCM Token: $token');

      // Register device with backend
      await _dio.post(
        '/device/register',
        data: {
          'device_token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
          'device_info': {
            'os_version': Platform.operatingSystemVersion,
            'app_version': '1.0.0', // TODO: Get from package info
          },
        },
      );

      debugPrint('Device registered successfully');
    } catch (e) {
      debugPrint('Error registering device: $e');
      // Don't throw - registration can fail silently
    }
  }

  /// Handle token refresh
  Future<void> _onTokenRefresh(String token) async {
    debugPrint('FCM token refreshed: $token');
    try {
      // Update token with backend
      await _dio.put(
        '/device/register',
        data: {
          'device_token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
        },
      );
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.messageId}');
    debugPrint('Message data: ${message.data}');

    // Show local notification for foreground messages
    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? 'ScoutMena',
        body: message.notification!.body ?? '',
        data: message.data,
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    debugPrint('Message data: ${message.data}');

    // Emit tap event for deep linking
    _notificationTapController.add(message.data);
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Notification channel for Android
      const androidChannel = AndroidNotificationDetails(
        'scoutmena_channel',
        'ScoutMena Notifications',
        channelDescription: 'Notifications from ScoutMena',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      // iOS notification details
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Notification details
      const notificationDetails = NotificationDetails(
        android: androidChannel,
        iOS: iosDetails,
      );

      // Show notification
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
        title,
        body,
        notificationDetails,
        payload: _encodePayload(data ?? {}),
      );

      debugPrint('Local notification shown: $title');
    } catch (e) {
      debugPrint('Error showing local notification: $e');
    }
  }

  /// Unregister device from backend
  Future<void> unregisterDevice() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _dio.delete(
          '/device/unregister',
          data: {'device_token': token},
        );
        debugPrint('Device unregistered successfully');
      }
    } catch (e) {
      debugPrint('Error unregistering device: $e');
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
    debugPrint('FCM token deleted');
  }

  /// Parse notification payload from JSON string
  Map<String, dynamic> _parsePayload(String payload) {
    try {
      // Simple parsing (extend as needed)
      final parts = payload.split('|');
      return {
        'type': parts.isNotEmpty ? parts[0] : '',
        'id': parts.length > 1 ? parts[1] : '',
      };
    } catch (e) {
      debugPrint('Error parsing payload: $e');
      return {};
    }
  }

  /// Encode data to payload string
  String _encodePayload(Map<String, dynamic> data) {
    return '${data['type'] ?? ''}|${data['id'] ?? ''}';
  }

  /// Dispose resources
  void dispose() {
    _notificationTapController.close();
  }
}

/// Deep link handler for notifications
class NotificationDeepLinkHandler {
  /// Handle notification tap and navigate
  static String? getRouteFromNotification(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    switch (type) {
      case 'profile_view':
        // Scout viewed player profile
        return '/player-profile/$id';

      case 'message':
        // New message received
        return '/messages/$id';

      case 'moderation':
        // Content moderation update
        return '/moderation-status';

      case 'system':
        // System announcement
        return '/announcements';

      case 'saved_search_match':
        // New player matches saved search
        return '/scout/search?searchId=$id';

      default:
        debugPrint('Unknown notification type: $type');
        return null;
    }
  }
}
