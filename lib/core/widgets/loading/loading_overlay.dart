import 'package:flutter/material.dart';

/// A full-screen loading overlay with a spinner and optional message
/// Used to block UI during critical operations (login, file uploads, etc.)
class LoadingOverlay extends StatelessWidget {
  final String? message;
  final bool isTransparent;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    this.message,
    this.isTransparent = false,
    this.backgroundColor,
  });

  /// Shows a loading overlay on top of the current screen
  static void show(
    BuildContext context, {
    String? message,
    bool isTransparent = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: isTransparent ? Colors.transparent : Colors.black54,
      builder: (context) => LoadingOverlay(
        message: message,
        isTransparent: isTransparent,
      ),
    );
  }

  /// Hides the loading overlay
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button dismissal
      child: Dialog(
        backgroundColor: backgroundColor ??
            (isTransparent ? Colors.transparent : Colors.white),
        elevation: isTransparent ? 0 : 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that shows a loading indicator in the center of the screen
/// Used as a state in screens when data is being loaded
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A small loading indicator for inline use (e.g., in buttons)
class InlineLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const InlineLoadingIndicator({
    super.key,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: color != null
            ? AlwaysStoppedAnimation<Color>(color!)
            : null,
      ),
    );
  }
}

/// A shimmer effect wrapper for custom loading states
class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const ShimmerWrapper({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
