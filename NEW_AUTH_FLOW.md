# New Authentication Flow - Updated November 12, 2025

## Overview

The authentication flow has been completely redesigned to provide a more streamlined user experience with onboarding, combined login/signup, and integrated role selection within the registration form.

## New Flow Diagram

```
Splash Screen
     ↓
Onboarding (3 screens) - Skippable
     ↓
Phone Auth (Combined Login/Signup)
     ↓
OTP Verification
     ↓
Registration Form (includes role selection, email, phone)
     ↓
Profile Creation Multi-step Screens (Player only)
     ↓
Dashboard (Player or Scout)
```

## Detailed Flow

### 1. Splash Screen
- **File**: `lib/features/onboarding/presentation/pages/splash_screen.dart`
- **Duration**: 2 seconds
- **Features**:
  - Animated fade-in of app logo
  - Loading indicator
  - Checks if user has seen onboarding
  - Navigates to onboarding (first time) or phone auth (returning)

### 2. Onboarding Screens
- **File**: `lib/features/onboarding/presentation/pages/onboarding_page.dart`
- **Screens**: 3 screens with placeholder images
- **Features**:
  - Skip button (top right)
  - Page indicators (dots)
  - "Next" button (changes to "Get Started" on last screen)
  - Saves completion state to SharedPreferences
  - Placeholder content:
    - Screen 1: "Discover Football Talent" - Onboarding 1
    - Screen 2: "Showcase Your Skills" - Onboarding 2
    - Screen 3: "Find the Next Star" - Onboarding 3

### 3. Phone Authentication
- **File**: `lib/features/authentication/presentation/pages/phone_auth_page.dart`
- **Mode**: Combined login/signup (no mode switching needed)
- **Features**:
  - International phone input with country code picker
  - Phone number validation
  - Terms & Conditions checkbox (required)
  - Google sign-in button (placeholder)
  - Apple sign-in button (placeholder)
  - Sends OTP via Firebase

### 4. OTP Verification
- **File**: `lib/features/authentication/presentation/pages/otp_verification_page.dart`
- **Features**:
  - 6-digit PIN code input
  - Auto-submit on completion
  - Resend code with 60-second countdown
  - After verification, attempts backend login with Firebase token
- **Navigation Logic**:
  - If user exists in backend → Go to dashboard (based on role)
  - If user doesn't exist → Go to registration form

### 5. Registration Form
- **File**: `lib/features/authentication/presentation/pages/registration_page.dart`
- **NEW**: Integrated role selection within the form
- **Fields**:
  1. **Role Selection** (NEW)
     - Player or Scout (uses RoleSelectionCard component)
     - Required field with validation
  2. **Full Name** (required)
  3. **Email** (required, with validation)
  4. **Phone** (auto-filled from OTP page)
  5. **Date of Birth** (required)
     - Automatically detects if user is minor (< 18)
  6. **Country** (required)
  7. **Parent/Guardian Information** (if minor)
     - Parent Name (required for minors)
     - Parent Email (required for minors)

- **COPPA Compliance**:
  - If user is under 18, parent/guardian info is required
  - Backend sends parental consent email
  - User account is pending until parent approves

- **Navigation After Registration**:
  - **Player** → Profile Creation Multi-step Screens
  - **Scout** → Scout Dashboard
  - **Minor** → Shows parental consent dialog, then returns to login

### 6. Profile Creation (Player Only)
- **File**: `lib/features/player/presentation/pages/player_profile_setup_page.dart`
- **Status**: Placeholder for Phase 3
- **Features**:
  - Placeholder screen with "Skip to Dashboard" button
  - TODO: Implement full multi-step profile creation:
    - Basic info (position, preferred foot, height, weight)
    - Football info (current club, years playing, achievements)
    - Contact preferences
    - Profile photo upload
    - Video uploads
    - Statistics

### 7. Dashboard
- **Player Dashboard**: `AppRoutes.playerDashboard`
- **Scout Dashboard**: `AppRoutes.scoutDashboard`
- **Status**: Placeholder for Phase 3

## Key Changes from Previous Flow

### Removed
- ✅ **Role Selection as separate screen** - Now integrated into registration form
- ✅ **Separate login/register modes** - Combined into single phone auth screen

### Added
- ✅ **Splash Screen** - Professional app launch experience
- ✅ **Onboarding Screens** (3 screens with placeholders)
- ✅ **Role selection in registration form** - More streamlined UX
- ✅ **Phone number field** in registration (auto-filled)

### Modified
- ✅ **Phone Auth Page** - No longer switches between login/register modes
- ✅ **OTP Verification** - Now navigates directly to registration (not role selection)
- ✅ **Registration Form** - Includes role selection and phone confirmation

## Route Updates

### New Routes Added
```dart
static const String splash = '/';              // NEW
static const String onboarding = '/onboarding'; // NEW
```

### Modified Routes
```dart
// Registration now requires phoneNumber instead of accountType
AppRoutes.registration:
  - OLD: firebaseUid, accountType
  - NEW: firebaseUid, phoneNumber, accountType (optional)
```

### Route Flow
```
1. AppRoutes.splash                     → SplashScreen
2. AppRoutes.onboarding                 → OnboardingPage (3 screens)
3. AppRoutes.phoneAuth                  → PhoneAuthPage (combined)
4. AppRoutes.otpVerification            → OTPVerificationPage
5. AppRoutes.registration               → RegistrationPage (with role selection)
6. AppRoutes.playerProfileSetup         → PlayerProfileSetupPage (placeholder)
7. AppRoutes.playerDashboard            → Player Dashboard (placeholder)
8. AppRoutes.scoutDashboard             → Scout Dashboard (placeholder)
```

## Files Created/Modified

### Created Files (5 files)
1. `lib/features/onboarding/presentation/pages/splash_screen.dart` - Splash screen with animation
2. `lib/features/onboarding/presentation/pages/onboarding_page.dart` - 3 onboarding screens
3. `lib/features/player/presentation/pages/player_profile_setup_page.dart` - Profile setup placeholder
4. `lib/core/navigation/routes.dart` - Added onboarding route
5. `NEW_AUTH_FLOW.md` - This documentation

### Modified Files (4 files)
1. `lib/main.dart`
   - Changed initialRoute to `AppRoutes.splash`
   - Added routes for splash, onboarding, playerProfileSetup
   - Updated registration route parameters

2. `lib/features/authentication/presentation/pages/otp_verification_page.dart`
   - Changed navigation from `AppRoutes.roleSelection` to `AppRoutes.registration`
   - Passes phoneNumber to registration

3. `lib/features/authentication/presentation/pages/registration_page.dart`
   - Added `phoneNumber` parameter (required)
   - Made `accountType` optional
   - Added `_selectedRole` state
   - Added role selection UI (Player/Scout cards)
   - Added role validation before submission
   - Added phone to userData
   - Updated navigation to `AppRoutes.playerProfileSetup` for players

4. `lib/core/navigation/routes.dart`
   - Added `onboarding` route constant

## Backend Integration

No changes to backend API required. The flow still uses the same endpoints:

- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/firebase-login` - Login with Firebase token
- `GET /api/v1/auth/me` - Get current user
- `POST /api/v1/auth/logout` - Logout

## Testing the New Flow

### First-Time User
1. App launches → Splash screen (2s)
2. → Onboarding screens (can skip)
3. → Phone Auth → Enter phone
4. → OTP Verification → Enter 6-digit code
5. → Registration Form → Select role, enter details
6. → Profile Setup (if player) OR Dashboard (if scout)

### Returning User (has seen onboarding)
1. App launches → Splash screen (2s)
2. → Phone Auth (skips onboarding)
3. → Continue with OTP verification...

## Next Steps (Phase 3)

1. **Replace placeholder images** in onboarding screens
2. **Implement full multi-step profile creation** for players:
   - Step 1: Basic Info
   - Step 2: Football Info
   - Step 3: Contact Preferences
   - Step 4: Photos/Videos
3. **Implement dashboards**:
   - Player Dashboard
   - Scout Dashboard
4. **Add social login**:
   - Google Sign-In
   - Apple Sign-In
5. **Email verification** flow

## Benefits of New Flow

✅ **Better UX**: Streamlined, modern onboarding experience
✅ **Reduced friction**: Combined login/signup, fewer screens
✅ **Clearer context**: Role selection integrated with registration
✅ **Professional feel**: Splash screen and onboarding
✅ **Flexibility**: Can add/replace onboarding images easily
✅ **Standards**: Follows common mobile app patterns

---

**Document Version**: 1.0
**Last Updated**: November 12, 2025
**Author**: Claude Code Assistant
