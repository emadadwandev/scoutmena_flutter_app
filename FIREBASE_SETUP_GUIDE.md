# Firebase Setup Guide - ScoutMena Flutter App

**Last Updated**: November 12, 2025

This guide will walk you through setting up Firebase for the ScoutMena Flutter app with support for both iOS and Android platforms.

---

## 📋 Prerequisites

Before starting, ensure you have:

- [ ] Flutter SDK installed (version 3.35.4 or higher)
- [ ] Active Google account for Firebase Console
- [ ] Node.js and npm installed (for Firebase CLI)
- [ ] Xcode installed (macOS only, for iOS)
- [ ] Android Studio installed (for Android)
- [ ] Project access/admin rights

---

## 🎯 Overview

We'll set up the following Firebase services:
1. **Firebase Authentication** (Phone Auth with SMS)
2. **Firebase Project** for ScoutMena
3. **iOS App Configuration**
4. **Android App Configuration**
5. **FlutterFire CLI Configuration**

---

## Part 1: Install Firebase CLI and FlutterFire CLI

### Step 1.1: Install Firebase CLI

**Windows**:
```bash
npm install -g firebase-tools
```

**macOS/Linux**:
```bash
curl -sL https://firebase.tools | bash
```

**Verify Installation**:
```bash
firebase --version
```

### Step 1.2: Login to Firebase

```bash
firebase login
```

This will open a browser window for you to authenticate with your Google account.

### Step 1.3: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

**Add to PATH** (if not already):

**Windows**: Add `%LOCALAPPDATA%\Pub\Cache\bin` to your PATH
**macOS/Linux**: Add `$HOME/.pub-cache/bin` to your PATH

**Verify Installation**:
```bash
flutterfire --version
```

---

## Part 2: Create Firebase Project

### Step 2.1: Go to Firebase Console

Open [Firebase Console](https://console.firebase.google.com/)

### Step 2.2: Create New Project

1. Click **"Add project"** or **"Create a project"**
2. **Project name**: `ScoutMena` (or your preferred name)
3. Click **"Continue"**

### Step 2.3: Google Analytics (Optional)

- **Enable Google Analytics**: Choose based on your needs
  - ✅ Recommended for production apps (tracking, analytics)
  - ❌ Can skip for development/testing
- Click **"Continue"**

### Step 2.4: Configure Google Analytics (if enabled)

- Select or create an Analytics account
- Click **"Create project"**
- Wait for project creation (30-60 seconds)

### Step 2.5: Project Created

- You'll see "Your new project is ready"
- Click **"Continue"**

---

## Part 3: Enable Phone Authentication

### Step 3.1: Navigate to Authentication

1. In Firebase Console, select your **ScoutMena** project
2. In left sidebar, click **"Build"** → **"Authentication"**
3. Click **"Get started"**

### Step 3.2: Enable Phone Provider

1. Click on **"Sign-in method"** tab
2. Find **"Phone"** in the providers list
3. Click on **"Phone"**
4. Toggle **"Enable"**
5. Click **"Save"**

### Step 3.3: Configure Phone Auth Settings

**For Production**:
- You may need to verify your domain
- Add authorized domains if deploying web version

**For Testing** (Optional):
1. Scroll down to **"Phone numbers for testing"**
2. Click **"Add phone number"**
3. Add test numbers with test codes (e.g., `+1 650 555 1234` → `123456`)
4. This allows testing without SMS costs

---

## Part 4: Configure Android App

### Step 4.1: Register Android App

1. In Firebase Console, on Project Overview page
2. Click the **Android icon** (or "Add app" → "Android")
3. Fill in the details:

**Android package name**:
```
com.scoutmena.app
```
> ⚠️ **IMPORTANT**: This must match the package name in your `android/app/build.gradle`

**App nickname** (optional):
```
ScoutMena Android
```

**Debug signing certificate SHA-1** (Optional, but recommended):

Get it by running:
```bash
cd android
./gradlew signingReport
```

**On Windows**:
```bash
cd android
gradlew signingReport
```

Look for `SHA1` under `Variant: debug` and copy it.

4. Click **"Register app"**

### Step 4.2: Download google-services.json

1. Click **"Download google-services.json"**
2. Move the file to: `android/app/google-services.json`

```bash
# From project root
# Place the downloaded file at:
scoutmena_flutter_app/android/app/google-services.json
```

### Step 4.3: Android Configuration Already Done ✅

Your project already has the necessary configuration in:
- `android/build.gradle` - Google services classpath
- `android/app/build.gradle` - Google services plugin

**Verify these lines exist**:

**android/build.gradle**:
```gradle
dependencies {
    classpath 'com.android.tools.build:gradle:8.1.0'
    classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0'
    classpath 'com.google.gms:google-services:4.4.0'  // ✅ Should be present
}
```

**android/app/build.gradle** (at the bottom):
```gradle
apply plugin: 'com.google.gms.google-services'  // ✅ Should be present
```

### Step 4.4: Update Package Name (if needed)

Check that your package name matches:

**android/app/build.gradle**:
```gradle
android {
    namespace "com.scoutmena.app"
    defaultConfig {
        applicationId "com.scoutmena.app"  // ✅ Must match Firebase registration
        // ...
    }
}
```

**android/app/src/main/AndroidManifest.xml**:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.scoutmena.app">  <!-- ✅ Must match -->
```

---

## Part 5: Configure iOS App

### Step 5.1: Register iOS App

1. In Firebase Console, on Project Overview page
2. Click the **iOS icon** (or "Add app" → "iOS")
3. Fill in the details:

**iOS bundle ID**:
```
com.scoutmena.app
```
> ⚠️ **IMPORTANT**: This must match the bundle identifier in your Xcode project

**App nickname** (optional):
```
ScoutMena iOS
```

**App Store ID** (optional): Leave empty for now

4. Click **"Register app"**

### Step 5.2: Download GoogleService-Info.plist

1. Click **"Download GoogleService-Info.plist"**
2. Keep this file - we'll add it to Xcode next

### Step 5.3: Add GoogleService-Info.plist to Xcode

**Option A: Using Xcode (Recommended)**

1. Open your iOS project in Xcode:
```bash
cd ios
open Runner.xcworkspace
```

2. In Xcode's Project Navigator (left sidebar):
   - Right-click on **"Runner"** folder (under Runner project)
   - Select **"Add Files to 'Runner'..."**
   - Navigate to your downloaded `GoogleService-Info.plist`
   - **✅ IMPORTANT**: Check **"Copy items if needed"**
   - **✅ IMPORTANT**: Ensure **"Runner"** target is selected
   - Click **"Add"**

3. Verify the file appears under `Runner > Runner` folder in Xcode

**Option B: Manual Copy**

```bash
# Copy GoogleService-Info.plist to ios/Runner/
cp ~/Downloads/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist
```

Then open in Xcode and add to project (follow Option A, step 2)

### Step 5.4: Update Bundle Identifier (if needed)

1. In Xcode, select **Runner** project (top of navigator)
2. Select **Runner** target
3. Go to **"Signing & Capabilities"** tab
4. **Bundle Identifier** should be: `com.scoutmena.app`
5. Update if different

### Step 5.5: Configure iOS Capabilities for Phone Auth

1. In Xcode, with Runner target selected
2. Go to **"Signing & Capabilities"** tab
3. Click **"+ Capability"**
4. Add **"Background Modes"**
5. Check **"Background fetch"** and **"Remote notifications"**

### Step 5.6: Update Info.plist for Phone Auth

Add the following to `ios/Runner/Info.plist` inside the `<dict>` tag:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

**To find your REVERSED_CLIENT_ID**:
1. Open `ios/Runner/GoogleService-Info.plist` in a text editor
2. Find the `REVERSED_CLIENT_ID` value
3. Replace `com.googleusercontent.apps.YOUR-CLIENT-ID` with that value

---

## Part 6: Run FlutterFire Configure (Automated Setup)

This command will automatically configure Firebase for all platforms:

### Step 6.1: Navigate to Project Root

```bash
cd f:\smbkp\scoutmena_flutter_app
```

### Step 6.2: Run FlutterFire Configure

```bash
flutterfire configure
```

### Step 6.3: Follow the Prompts

1. **Select a Firebase project**:
   - Use arrow keys to select **ScoutMena** (the project you created)
   - Press Enter

2. **Select platforms**:
   - Use spacebar to select:
     - ✅ android
     - ✅ ios
   - Press Enter

3. **Confirm platforms**:
   - Review the list
   - Press Enter to confirm

4. **Wait for configuration**:
   - FlutterFire CLI will:
     - Generate `lib/firebase_options.dart`
     - Update platform-specific files
     - Download configuration files (if not already present)

### Step 6.4: Verify Generated Files

Check that these files were created/updated:

```
✅ lib/firebase_options.dart (generated)
✅ android/app/google-services.json
✅ ios/Runner/GoogleService-Info.plist
✅ ios/firebase_app_id_file.json (generated)
```

---

## Part 7: Update App Code to Use Firebase

### Step 7.1: Verify Dependencies

Check that `pubspec.yaml` has the required packages:

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.3
  # ... other dependencies
```

### Step 7.2: Install Dependencies

```bash
flutter pub get
```

### Step 7.3: Initialize Firebase in main.dart

Your `lib/main.dart` should already have Firebase initialization. Verify it looks like this:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ... rest of initialization
  runApp(const MyApp());
}
```

### Step 7.4: Disable Testing Mode

**⚠️ CRITICAL**: Update `lib/core/constants/app_constants.dart`:

```dart
// Testing/Development - IMPORTANT: SET TO FALSE IN PRODUCTION!
static const bool bypassOTPVerification = false;  // ⚠️ Change to false
static const String testOTP = '123456';
static const String testVerificationId = 'test-verification-id';
```

---

## Part 8: Configure Phone Auth Verification

### Step 8.1: Android - Enable SafetyNet API (Optional but Recommended)

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project (ScoutMena)
3. Search for **"Android Device Verification API"**
4. Click **"Enable"**
5. Also enable **"SafetyNet API"** if available

### Step 8.2: iOS - Enable APNs (Apple Push Notification Service)

**Required for iOS Phone Auth to work!**

1. Go to [Apple Developer Account](https://developer.apple.com/account/)
2. Navigate to **"Certificates, Identifiers & Profiles"**
3. Select **"Keys"**
4. Click **"+"** to create a new key
5. Name it: `ScoutMena APNs Key`
6. Check **"Apple Push Notifications service (APNs)"**
7. Click **"Continue"** then **"Register"**
8. **Download the .p8 key file** (you can only download once!)
9. Note your **Key ID** and **Team ID**

### Step 8.3: Upload APNs Key to Firebase

1. Go to Firebase Console → **Project Settings** (gear icon)
2. Select **"Cloud Messaging"** tab
3. Scroll to **"Apple app configuration"**
4. Under **"APNs Authentication Key"**:
   - Click **"Upload"**
   - Select your downloaded .p8 file
   - Enter **Key ID**
   - Enter **Team ID** (found in Apple Developer Account)
5. Click **"Upload"**

---

## Part 9: Test the Setup

### Step 9.1: Clean Build

```bash
flutter clean
flutter pub get
```

### Step 9.2: Build Android

```bash
flutter build apk --debug
# or run on device
flutter run -d android
```

**Check for**:
- ✅ App launches without Firebase errors
- ✅ No "FirebaseOptions not found" errors
- ✅ Phone auth screen shows correctly

### Step 9.3: Build iOS

```bash
cd ios
pod install
cd ..
flutter run -d ios
```

**Check for**:
- ✅ App launches without Firebase errors
- ✅ No Firebase configuration errors
- ✅ Phone auth screen shows correctly

### Step 9.4: Test Phone Authentication

1. Launch the app
2. Go through onboarding
3. Enter a **real phone number** (your phone)
4. Click **"Send OTP"**
5. Check that you receive an SMS with the code
6. Enter the code
7. Verify you can complete registration

**Common Test Numbers**:
- Your personal phone
- Test phone numbers configured in Firebase Console

---

## Part 10: Production Configuration

### Step 10.1: App Verification (Android)

For production, enable **App Check** to prevent abuse:

1. Firebase Console → **Build** → **App Check**
2. Click **"Get started"**
3. Register your apps:
   - **Android**: Use Play Integrity API
   - **iOS**: Use App Attest

### Step 10.2: Set Usage Quotas

1. Firebase Console → **Authentication**
2. Click **"Settings"** tab
3. Review and adjust quotas:
   - SMS quota per hour
   - Maximum attempts per device
   - Verification code timeout

### Step 10.3: Add Authorized Domains (if using Web)

1. Firebase Console → **Authentication** → **Settings**
2. Scroll to **"Authorized domains"**
3. Add your production domains

---

## 🐛 Troubleshooting

### Issue: "FirebaseOptions not found"

**Fix**:
```bash
flutterfire configure
flutter pub get
flutter clean
```

### Issue: "google-services.json not found" (Android)

**Fix**:
- Ensure file is at: `android/app/google-services.json`
- Not at: `android/google-services.json` (wrong location)

### Issue: "GoogleService-Info.plist not found" (iOS)

**Fix**:
- Open Xcode: `open ios/Runner.xcworkspace`
- Check file is in Runner folder
- Ensure "Copy Bundle Resources" includes the file

### Issue: iOS Phone Auth not receiving SMS

**Fixes**:
- ✅ Verify APNs key is uploaded to Firebase
- ✅ Check Bundle ID matches Firebase registration
- ✅ Ensure Background Modes are enabled in Xcode
- ✅ Test on real device (simulator may not work)

### Issue: Android Phone Auth not working

**Fixes**:
- ✅ Verify SHA-1 fingerprint is added to Firebase
- ✅ Check package name matches Firebase registration
- ✅ Enable SafetyNet API in Google Cloud Console

### Issue: "Invalid API Key"

**Fix**:
- Delete and re-download configuration files
- Run `flutterfire configure` again
- Ensure you're using the correct Firebase project

---

## 📝 Checklist - Complete Setup

### Firebase Console
- [ ] Firebase project created (ScoutMena)
- [ ] Phone authentication enabled
- [ ] Android app registered with correct package name
- [ ] iOS app registered with correct bundle ID
- [ ] APNs key uploaded (iOS)
- [ ] SafetyNet API enabled (Android)

### Android
- [ ] `google-services.json` in `android/app/`
- [ ] SHA-1 fingerprint added to Firebase
- [ ] Package name matches in all files
- [ ] App builds and runs without errors

### iOS
- [ ] `GoogleService-Info.plist` in `ios/Runner/`
- [ ] File added to Xcode project properly
- [ ] Bundle identifier matches in all files
- [ ] APNs configured
- [ ] Background modes enabled
- [ ] App builds and runs without errors

### Flutter Code
- [ ] `firebase_options.dart` generated
- [ ] Firebase initialized in `main.dart`
- [ ] `bypassOTPVerification = false` in `app_constants.dart`
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Clean build successful

### Testing
- [ ] Phone auth sends real SMS
- [ ] OTP verification works
- [ ] Registration completes successfully
- [ ] No Firebase errors in console

---

## 🚀 Next Steps After Setup

1. **Test with real phone numbers** on both platforms
2. **Configure App Check** for production security
3. **Set up Cloud Firestore** (if needed for backend)
4. **Enable Crashlytics** for error monitoring
5. **Configure Analytics** events

---

## 📞 Support & Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Phone Auth Guide](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)

---

## 📋 Important Files Reference

```
scoutmena_flutter_app/
├── android/
│   ├── app/
│   │   ├── google-services.json          ⚠️ From Firebase
│   │   └── build.gradle                  ⚠️ Contains package name
│   └── build.gradle                      ⚠️ Contains Google services plugin
├── ios/
│   ├── Runner/
│   │   ├── GoogleService-Info.plist      ⚠️ From Firebase
│   │   └── Info.plist                    ⚠️ Contains bundle ID
│   └── Runner.xcworkspace                ⚠️ Open this in Xcode
├── lib/
│   ├── firebase_options.dart             ⚠️ Generated by FlutterFire
│   ├── core/
│   │   └── constants/
│   │       └── app_constants.dart        ⚠️ Set bypassOTPVerification = false
│   └── main.dart                         ⚠️ Firebase initialization
└── pubspec.yaml                          ⚠️ Firebase dependencies
```

---

**Version**: 1.0
**Last Updated**: November 12, 2025
**Status**: Ready for Firebase Setup

---

## Quick Reference Commands

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase for Flutter
flutterfire configure

# Get dependencies
flutter pub get

# Clean build
flutter clean

# Run on Android
flutter run -d android

# Run on iOS
flutter run -d ios

# Generate APK
flutter build apk --release

# Generate iOS archive
flutter build ios --release
```

---

**Good luck with your Firebase setup! 🚀**
