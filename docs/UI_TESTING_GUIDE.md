# UI Testing Guide - Firebase Auth Bypass

**Date:** November 13, 2025  
**Purpose:** Enable visual UI testing without Firebase authentication

## ⚠️ IMPORTANT: Development Mode Only

**These settings must be set to `false` before production deployment!**

## Quick Start - Bypass Firebase Authentication

### 1. Current Configuration ✅

The following flags are **already enabled** in `lib/core/constants/app_constants.dart`:

```dart
// Testing/Development - IMPORTANT: SET TO FALSE IN PRODUCTION!
static const bool bypassOTPVerification = true;
static const String testOTP = '123456';
static const String testVerificationId = 'test-verification-id';

// Firebase Auth Bypass for UI Testing
static const bool bypassFirebaseAuth = true; // ✅ ENABLED
static const String mockFirebaseToken = 'mock-firebase-token-for-testing';
static const String mockUserId = 'test-user-123';

// UI Testing Mode - Bypass all authentication checks
static const bool enableUITestingMode = true; // ✅ ENABLED
```

### 2. What's Bypassed

With these flags enabled:

✅ **API Authentication**: Mock Firebase token sent with all API requests  
✅ **Token Refresh**: No real Firebase token validation  
✅ **User ID**: Returns mock user ID (`test-user-123`)  
✅ **OTP Verification**: Accept any OTP (hardcoded `123456`)  
✅ **Auth State**: Bypass Firebase auth checks

### 3. How to Use

#### Option A: Run the App Normally
```bash
flutter run -d emulator-5554
```

The app will automatically use mock authentication tokens.

#### Option B: Hot Restart to Apply Changes
```bash
# If app is already running, hot restart
press 'R' in terminal
```

### 4. Test Authentication Flow

1. **Launch App**: App opens directly
2. **Phone Auth Page**: Enter any phone number
3. **OTP Page**: Enter `123456` (or any code if bypass enabled)
4. **Access Protected Routes**: All API calls use mock token

### 5. Temporary Disable (for real Firebase testing)

To test real Firebase authentication, temporarily change in `app_constants.dart`:

```dart
static const bool bypassFirebaseAuth = false; // Disable bypass
static const bool enableUITestingMode = false; // Disable testing mode
static const bool bypassOTPVerification = false; // Require real OTP
```

Then hot restart the app.

## Current Implementation Details

### Modified Files

#### 1. `lib/core/constants/app_constants.dart` ✅
Added bypass flags for testing mode.

#### 2. `lib/core/network/api_client.dart` ✅
```dart
// In onRequest interceptor:
if (AppConstants.enableUITestingMode && AppConstants.bypassFirebaseAuth) {
  options.headers['Authorization'] = 'Bearer ${AppConstants.mockFirebaseToken}';
  return handler.next(options);
}
```

#### 3. `lib/core/services/firebase_auth_service.dart` ✅
```dart
// In getFirebaseToken():
if (AppConstants.enableUITestingMode && AppConstants.bypassFirebaseAuth) {
  await _secureStorage.write(
    key: 'firebase_token', 
    value: AppConstants.mockFirebaseToken,
  );
  return AppConstants.mockFirebaseToken;
}

// In getCurrentUserId():
if (AppConstants.enableUITestingMode && AppConstants.bypassFirebaseAuth) {
  return AppConstants.mockUserId;
}
```

## Backend Considerations

### Mock Token Format

The mock token `mock-firebase-token-for-testing` is sent as:
```
Authorization: Bearer mock-firebase-token-for-testing
```

### Backend Setup Options

#### Option 1: Backend Bypass (Recommended for UI Testing)

Configure your Laravel backend to accept mock tokens in development:

**File:** `ScoutMena/app/Http/Middleware/FirebaseAuthenticate.php`

```php
public function handle(Request $request, Closure $next)
{
    // Development bypass for UI testing
    if (config('app.env') === 'local' && config('app.debug') === true) {
        $mockToken = 'mock-firebase-token-for-testing';
        
        if ($request->bearerToken() === $mockToken) {
            // Create mock user for testing
            $request->merge([
                'firebase_uid' => 'test-user-123',
                'is_mock_auth' => true,
            ]);
            
            return $next($request);
        }
    }
    
    // Normal Firebase token validation...
}
```

#### Option 2: Use Staging User

Create a real Firebase user for testing and use that token.

#### Option 3: Disable Auth Middleware (Not Recommended)

Temporarily disable auth middleware in routes (risky).

## Testing Scenarios

### Scenario 1: UI Component Testing
**Purpose:** Test layouts, styles, animations without backend  
**Setup:** Keep bypass enabled, mock backend responses  
**Commands:**
```bash
flutter run -d emulator-5554
```

### Scenario 2: Navigation Flow Testing
**Purpose:** Test screen transitions, route guards  
**Setup:** Bypass enabled, test navigation paths  
**Focus:** AppBar, BottomNav, Drawer, Routes

### Scenario 3: Form Validation Testing
**Purpose:** Test form fields, validation without submission  
**Setup:** Bypass enabled, forms work without API  
**Focus:** TextFields, Dropdowns, Date Pickers

### Scenario 4: State Management Testing
**Purpose:** Test BLoC states, loading indicators  
**Setup:** Bypass enabled, simulate different states  
**Focus:** Loading, Success, Error states

## Common Issues & Solutions

### Issue 1: "Token not found" errors

**Solution:** Ensure `enableUITestingMode = true` in app_constants.dart

### Issue 2: API returns 401 Unauthorized

**Solution:** 
- Check backend is accepting mock token
- Verify `bypassFirebaseAuth = true`
- Check API logs for token value

### Issue 3: Auth state not persisting

**Solution:** Mock token is stored in secure storage, should persist across restarts

### Issue 4: Real Firebase conflicts

**Solution:** 
- Clear app data: Settings → Apps → ScoutMena → Clear Data
- Restart app
- Or uninstall and reinstall

## Debugging Commands

### Check Current Token
```dart
// Add to any screen's initState:
final token = await getIt<FirebaseAuthService>().getFirebaseToken();
print('Current Token: $token');
```

### Check Auth State
```dart
final userId = getIt<FirebaseAuthService>().getCurrentUserId();
print('User ID: $userId');
```

### Check API Headers
Look for in console logs:
```
[DioLogger] ╔ REQUEST
[DioLogger] ║ Authorization: Bearer mock-firebase-token-for-testing
```

## Performance Testing with Bypass

### Measure Screen Load Times
```bash
flutter run --profile -d emulator-5554
```

### DevTools Analysis
1. Open DevTools: `flutter pub global run devtools`
2. Navigate to Performance tab
3. Bypass allows testing without auth delays

## Visual Regression Testing

### Take Screenshots
```bash
flutter drive --target=test_driver/app.dart
```

### Compare UI States
With bypass enabled, can capture UI in different states without auth delays.

## Accessibility Testing

### Screen Reader Testing
```bash
flutter run -d emulator-5554
# Enable TalkBack (Android) or VoiceOver (iOS)
```

Bypass allows testing accessibility without login flows.

## Before Production Deployment

### Pre-flight Checklist

- [ ] Set `bypassFirebaseAuth = false`
- [ ] Set `enableUITestingMode = false`
- [ ] Set `bypassOTPVerification = false`
- [ ] Test real Firebase authentication flow
- [ ] Verify token refresh works
- [ ] Test 401 error handling
- [ ] Remove backend mock token acceptance
- [ ] Test production Firebase project

### Verification Commands

```bash
# Search for enabled bypass flags
grep -r "bypassFirebaseAuth = true" lib/
grep -r "enableUITestingMode = true" lib/

# Should return no results if properly disabled
```

## Environment-Specific Configuration

### Future Enhancement: Use Flavors

Create separate configurations:

```dart
// lib/core/config/env_config.dart
class EnvConfig {
  static bool get bypassAuth => 
    const bool.fromEnvironment('BYPASS_AUTH', defaultValue: false);
}
```

Run with:
```bash
flutter run --dart-define=BYPASS_AUTH=true
```

## Additional Testing Tools

### 1. Mock Server (Optional)
Use `mockito` or `json_server` to mock backend entirely.

### 2. Network Interceptor
Add custom Dio interceptor to return mock responses:

```dart
_dio.interceptors.add(MockInterceptor());
```

### 3. Golden Tests
Test UI appearance with:
```bash
flutter test --update-goldens
```

## Support & Troubleshooting

### Check Implementation
```bash
# Verify ApiClient has bypass
cat lib/core/network/api_client.dart | grep "enableUITestingMode"

# Verify FirebaseAuthService has bypass
cat lib/core/services/firebase_auth_service.dart | grep "enableUITestingMode"
```

### Reset Everything
```bash
# Clear app data
flutter clean
flutter pub get

# Uninstall app
adb uninstall com.scoutmena.app

# Reinstall
flutter run -d emulator-5554
```

## Current Status

✅ **Firebase Auth Bypass**: Enabled  
✅ **Mock Token**: Configured  
✅ **Mock User ID**: Configured  
✅ **OTP Bypass**: Enabled  
✅ **API Client**: Updated  
✅ **Auth Service**: Updated  

**Ready for UI Testing!** 🎉

---

**Remember:** Disable all bypass flags before production deployment!
