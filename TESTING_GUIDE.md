# Testing Guide - ScoutMena Flutter App

**Last Updated**: November 12, 2025

---

## 🎯 Testing Mode Enabled

The app is currently configured for **TESTING MODE** with OTP bypass enabled. This allows you to test the entire authentication flow without Firebase.

### ⚠️ IMPORTANT: Production Checklist

Before deploying to production, you **MUST** change the following in `lib/core/constants/app_constants.dart`:

```dart
// Change this line:
static const bool bypassOTPVerification = true;

// To this:
static const bool bypassOTPVerification = false;
```

---

## 🧪 How to Test the App

### Test Credentials

- **Test OTP**: `123456`
- **Any phone number** will work (no actual SMS sent)

### Complete Flow Test

Follow these steps to test the entire authentication flow:

#### 1. Launch the App
```bash
cd scoutmena_flutter_app
flutter run
```

**Expected**:
- App shows splash screen (2 seconds)
- Then shows onboarding screens (3 screens with placeholders)

#### 2. Onboarding Screens
- **Swipe** through 3 onboarding screens, OR
- **Tap "Skip"** button (top right)

**Expected**:
- Navigate to Phone Auth screen

#### 3. Phone Authentication
- Enter **any phone number** (e.g., +966 50 123 4567)
- Check the **Terms & Conditions** checkbox
- Tap **"Send OTP"** or **"Login"** button

**Expected**:
- Navigate to OTP Verification screen (no actual SMS sent)

#### 4. OTP Verification
- Enter the test OTP: **`123456`**
- Tap **"Verify"** button

**Expected**:
- Navigate to Registration Form

#### 5. Registration Form

Fill in all required fields:

**Select Role** (Choose one):
- ⚽ Player (Blue)
- 👁️ Scout (Green)
- 🏃 Coach (Pink/Magenta) ✨ NEW

**Personal Information**:
- Full Name: `Test User`
- Email: `test@example.com`
- Date of Birth: Select any date
- Country: `Saudi Arabia`

**If Minor (Under 18)**:
- Parent/Guardian Name: `Parent Name`
- Parent/Guardian Email: `parent@example.com`

Tap **"Register"** button

**Expected**:
- **Player**: Navigate to Profile Setup screen
- **Scout/Coach**: Navigate to Dashboard
- **Minor**: Show parental consent dialog

---

## 🎨 Testing All 3 Roles

### Test as Player
1. Follow steps 1-5 above
2. Select **Player** role (Blue card)
3. Complete registration
4. **Expected**: Navigate to "Profile Setup" placeholder screen
5. Tap "Skip to Dashboard"
6. **Expected**: Navigate to Player Dashboard

### Test as Scout
1. Follow steps 1-5 above
2. Select **Scout** role (Green card)
3. Complete registration
4. **Expected**: Navigate directly to Scout Dashboard

### Test as Coach (NEW)
1. Follow steps 1-5 above
2. Select **Coach** role (Pink card) ✨
3. Complete registration
4. **Expected**: Navigate to Dashboard

---

## 📱 Testing on Different Platforms

### Android
```bash
flutter run -d <android-device-id>
```

### iOS (macOS only)
```bash
flutter run -d <ios-device-id>
```

### Web (for quick testing)
```bash
flutter run -d chrome
```

---

## 🐛 Known Testing Limitations

### 1. Backend API Integration
- Testing mode bypasses Firebase authentication
- Registration will still try to hit the backend API at `https://api.scoutmena.com/api/v1`
- If backend is not running, registration will fail
- **Workaround**: Mock the backend or test only up to the registration screen

### 2. Profile Setup
- Player profile setup is a placeholder
- Only shows "Skip to Dashboard" button
- Full implementation coming in Phase 3

### 3. Dashboards
- All dashboards are placeholders
- Show "Coming in Phase 3" message

### 4. Social Login
- Google and Apple sign-in buttons are placeholders
- No functionality implemented yet

---

## 🧪 Test Scenarios

### Scenario 1: First-Time User (Happy Path)
1. ✅ Launch app → See splash screen
2. ✅ See onboarding (3 screens)
3. ✅ Enter phone number + accept terms
4. ✅ Enter OTP: `123456`
5. ✅ Select role + fill registration form
6. ✅ Arrive at profile setup or dashboard

### Scenario 2: Returning User (Skip Onboarding)
1. ✅ Launch app → See splash screen
2. ✅ Skip onboarding (already seen)
3. ✅ Go directly to phone auth
4. ✅ Continue with authentication

### Scenario 3: Minor Registration
1. ✅ Launch app
2. ✅ Complete phone auth + OTP
3. ✅ Select role
4. ✅ Enter date of birth (under 18)
5. ✅ Form shows parent/guardian fields
6. ✅ Fill parent information
7. ✅ Submit registration
8. ✅ See parental consent dialog

### Scenario 4: Invalid OTP
1. ✅ Launch app
2. ✅ Complete phone auth
3. ❌ Enter wrong OTP (not `123456`)
4. ✅ See error message with hint

### Scenario 5: Role Selection Validation
1. ✅ Launch app
2. ✅ Complete phone auth + OTP
3. ❌ Don't select a role
4. ✅ Try to submit
5. ✅ See error: "Please select a role to continue"

### Scenario 6: Test All 3 Roles
1. ✅ Test as Player → Profile Setup
2. ✅ Test as Scout → Dashboard
3. ✅ Test as Coach → Dashboard ✨ NEW

---

## 📊 What to Test

### UI/UX
- [ ] Splash screen animation is smooth
- [ ] Onboarding screens swipe correctly
- [ ] Skip button works
- [ ] Phone input shows country flags
- [ ] Terms checkbox works
- [ ] OTP input auto-advances between digits
- [ ] Role cards highlight when selected
- [ ] Form validation shows errors
- [ ] Minor detection shows parent fields
- [ ] Loading states show properly

### Navigation
- [ ] Splash → Onboarding (first time)
- [ ] Splash → Phone Auth (returning)
- [ ] Phone Auth → OTP Verification
- [ ] OTP → Registration
- [ ] Registration → Profile Setup (Player)
- [ ] Registration → Dashboard (Scout/Coach)
- [ ] Back button works correctly

### Functionality
- [ ] Can enter any phone number
- [ ] OTP `123456` is accepted
- [ ] Wrong OTP shows error
- [ ] All 3 roles are selectable
- [ ] Form validates required fields
- [ ] Email validation works
- [ ] Date picker works
- [ ] Minor detection (age < 18) works
- [ ] Parent fields required for minors

### Languages (if implemented)
- [ ] English language works
- [ ] Arabic language works
- [ ] RTL layout for Arabic
- [ ] Fonts: Tomorrow (EN), Cairo (AR)

---

## 🔧 Debugging Tips

### Check Console Output
Look for these messages:
- `[PhoneAuth] Bypass mode enabled`
- `[OTP] Test OTP accepted: 123456`
- `[Registration] User registered with role: player/scout/coach`

### Common Issues

#### Issue: Stuck on splash screen
- **Fix**: Check console for errors
- **Fix**: Ensure SharedPreferences is working

#### Issue: OTP not accepting `123456`
- **Fix**: Check `AppConstants.bypassOTPVerification` is `true`
- **Fix**: Check `AppConstants.testOTP` value

#### Issue: Registration fails
- **Fix**: Check if backend API is running
- **Fix**: Check network connectivity
- **Fix**: Look at console for API errors

#### Issue: Navigation doesn't work
- **Fix**: Check that routes are registered in `main.dart`
- **Fix**: Check arguments are passed correctly

---

## 📸 Screenshot Checklist

When testing, capture screenshots of:
1. [ ] Splash screen
2. [ ] Onboarding screen 1
3. [ ] Onboarding screen 2
4. [ ] Onboarding screen 3
5. [ ] Phone auth screen
6. [ ] OTP verification screen
7. [ ] Registration form with Player selected
8. [ ] Registration form with Scout selected
9. [ ] Registration form with Coach selected ✨ NEW
10. [ ] Registration form with minor (parent fields visible)
11. [ ] Profile setup placeholder
12. [ ] Dashboard placeholder

---

## 🚀 Ready for Production

Before going to production:

### Code Changes
1. [ ] Set `bypassOTPVerification = false` in `app_constants.dart`
2. [ ] Remove test constants (`testOTP`, `testVerificationId`)
3. [ ] Configure actual Firebase project with `flutterfire configure`
4. [ ] Test with real phone numbers and OTP
5. [ ] Add actual onboarding images (replace placeholders)

### Testing
1. [ ] Test on real Android device
2. [ ] Test on real iOS device
3. [ ] Test with real Firebase OTP
4. [ ] Test with real backend API
5. [ ] Test all user flows end-to-end
6. [ ] Test parental consent email flow

### Performance
1. [ ] App launches in < 2 seconds
2. [ ] Screen transitions are smooth
3. [ ] No memory leaks
4. [ ] Images load efficiently

---

## 📝 Test Report Template

After testing, fill in this report:

```
Test Date: _______________
Tester: _______________
Device: _______________
OS Version: _______________

PASSED:
- [ ] Splash screen
- [ ] Onboarding
- [ ] Phone auth
- [ ] OTP verification
- [ ] Registration (Player)
- [ ] Registration (Scout)
- [ ] Registration (Coach)
- [ ] Minor flow
- [ ] Navigation

FAILED:
- [ ] Issue 1: _______________
- [ ] Issue 2: _______________

NOTES:
_______________
_______________
```

---

**Document Version**: 1.0
**Last Updated**: November 12, 2025
**Status**: Testing Mode Enabled ⚠️
