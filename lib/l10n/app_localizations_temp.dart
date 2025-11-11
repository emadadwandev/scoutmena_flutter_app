import 'package:flutter/material.dart';

/// Temporary localization class until flutter gen-l10n generates the proper one
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common translations
  String get appName => locale.languageCode == 'ar' ? 'سكاوت مينا' : 'ScoutMena';
  String get welcome => locale.languageCode == 'ar' ? 'مرحباً بك في سكاوت مينا' : 'Welcome to ScoutMena';
  String get english => locale.languageCode == 'ar' ? 'الإنجليزية' : 'English';
  String get arabic => locale.languageCode == 'ar' ? 'العربية' : 'Arabic';
  String get lightMode => locale.languageCode == 'ar' ? 'فاتح' : 'Light';
  String get darkMode => locale.languageCode == 'ar' ? 'داكن' : 'Dark';
  String get systemMode => locale.languageCode == 'ar' ? 'النظام' : 'System';
  
  // Phone Auth Page
  String get welcomeToScoutMena => locale.languageCode == 'ar' ? 'مرحباً بك في سكاوت مينا' : 'Welcome to ScoutMena';
  String get enterPhoneToGetStarted => locale.languageCode == 'ar' ? 'أدخل رقم هاتفك للبدء' : 'Enter your phone number to get started';
  String get createAccount => locale.languageCode == 'ar' ? 'إنشاء حساب جديد' : 'Create New Account';
  String get registerDescription => locale.languageCode == 'ar' ? 'أدخل رقم هاتفك لإنشاء حساب' : 'Enter your phone number to create an account';
  String get phoneNumber => locale.languageCode == 'ar' ? 'رقم الهاتف' : 'Phone Number';
  String get phoneRequired => locale.languageCode == 'ar' ? 'رقم الهاتف مطلوب' : 'Phone number is required';
  String get pleaseAcceptTerms => locale.languageCode == 'ar' ? 'يرجى قبول الشروط والأحكام' : 'Please accept the terms and conditions';
  String get iAgreeToThe => locale.languageCode == 'ar' ? 'أوافق على' : 'I agree to the';
  String get termsAndConditions => locale.languageCode == 'ar' ? 'الشروط والأحكام' : 'Terms and Conditions';
  String get and => locale.languageCode == 'ar' ? 'و' : 'and';
  String get privacyPolicy => locale.languageCode == 'ar' ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get sendOTP => locale.languageCode == 'ar' ? 'إرسال رمز التحقق' : 'Send OTP';
  String get login => locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Login';
  String get dontHaveAccount => locale.languageCode == 'ar' ? 'ليس لديك حساب؟' : "Don't have an account?";
  String get registerNow => locale.languageCode == 'ar' ? 'سجل الآن' : 'Register now';
  String get alreadyHaveAccount => locale.languageCode == 'ar' ? 'لديك حساب بالفعل؟' : 'Already have an account?';
  String get loginNow => locale.languageCode == 'ar' ? 'سجل الدخول' : 'Login now';
  String get orContinueWith => locale.languageCode == 'ar' ? 'أو المتابعة مع' : 'Or continue with';
  String get continueWithGoogle => locale.languageCode == 'ar' ? 'المتابعة مع Google' : 'Continue with Google';
  String get continueWithApple => locale.languageCode == 'ar' ? 'المتابعة مع Apple' : 'Continue with Apple';
  
  // OTP Verification Page
  String get verifyPhoneNumber => locale.languageCode == 'ar' ? 'تحقق من رقم الهاتف' : 'Verify Phone Number';
  String get weHaveSentOTPTo => locale.languageCode == 'ar' ? 'لقد أرسلنا رمز التحقق إلى' : 'We have sent an OTP to';
  String get accountAlreadyExists => locale.languageCode == 'ar' ? 'الحساب موجود بالفعل. تم تسجيل دخولك.' : 'Account already exists. You are now logged in.';
  String get otpRequired => locale.languageCode == 'ar' ? 'يرجى إدخال رمز التحقق المكون من 6 أرقام' : 'Please enter the 6-digit OTP';
  String get resendCode => locale.languageCode == 'ar' ? 'إعادة إرسال الرمز' : 'Resend Code';
  String get resendCodeIn => locale.languageCode == 'ar' ? 'إعادة إرسال الرمز في' : 'Resend code in';
  String get seconds => locale.languageCode == 'ar' ? 'ثانية' : 'seconds';
  String get verify => locale.languageCode == 'ar' ? 'تحقق' : 'Verify';
  String get otpResent => locale.languageCode == 'ar' ? 'تم إعادة إرسال رمز التحقق بنجاح' : 'OTP code resent successfully';
  
  // Role Selection Page
  String get selectYourRole => locale.languageCode == 'ar' ? 'اختر دورك' : 'Select Your Role';
  String get chooseAccountType => locale.languageCode == 'ar' ? 'اختر نوع حسابك للمتابعة' : 'Choose your account type to continue';
  String get player => locale.languageCode == 'ar' ? 'لاعب' : 'Player';
  String get playerRoleDescription => locale.languageCode == 'ar' ? 'أنشئ ملفك الشخصي، اعرض موهبتك، واحصل على فرصة الاكتشاف من قبل الكشافة' : 'Create your profile, showcase your talent, and get discovered by scouts';
  String get scout => locale.languageCode == 'ar' ? 'كشاف' : 'Scout';
  String get scoutRoleDescription => locale.languageCode == 'ar' ? 'ابحث عن اللاعبين الموهوبين، احفظ عمليات البحث، واكتشف نجم كرة القدم القادم' : 'Find talented players, save searches, and discover the next football star';
  String get pleaseSelectRole => locale.languageCode == 'ar' ? 'يرجى اختيار دور للمتابعة' : 'Please select a role to continue';
  String get continueText => locale.languageCode == 'ar' ? 'متابعة' : 'Continue';
  
  // Registration Page
  String get registration => locale.languageCode == 'ar' ? 'التسجيل' : 'Registration';
  String get completeYourProfile => locale.languageCode == 'ar' ? 'أكمل ملفك الشخصي' : 'Complete Your Profile';
  String get tellUsAboutYourself => locale.languageCode == 'ar' ? 'أخبرنا عن نفسك' : 'Tell us about yourself';
  String get fullName => locale.languageCode == 'ar' ? 'الاسم الكامل' : 'Full Name';
  String get enterFullName => locale.languageCode == 'ar' ? 'أدخل اسمك الكامل' : 'Enter your full name';
  String get nameRequired => locale.languageCode == 'ar' ? 'الاسم مطلوب' : 'Name is required';
  String get email => locale.languageCode == 'ar' ? 'البريد الإلكتروني' : 'Email';
  String get enterEmail => locale.languageCode == 'ar' ? 'أدخل عنوان بريدك الإلكتروني' : 'Enter your email address';
  String get emailRequired => locale.languageCode == 'ar' ? 'البريد الإلكتروني مطلوب' : 'Email is required';
  String get invalidEmail => locale.languageCode == 'ar' ? 'عنوان بريد إلكتروني غير صحيح' : 'Invalid email address';
  String get dateOfBirth => locale.languageCode == 'ar' ? 'تاريخ الميلاد' : 'Date of Birth';
  String get selectDateOfBirth => locale.languageCode == 'ar' ? 'اختر تاريخ ميلادك' : 'Select your date of birth';
  String get dateOfBirthRequired => locale.languageCode == 'ar' ? 'تاريخ الميلاد مطلوب' : 'Date of birth is required';
  String get minorAccountNotice => locale.languageCode == 'ar' ? 'أنت دون سن 18. معلومات ولي الأمر مطلوبة.' : 'You are under 18. Parent/Guardian information is required.';
  String get country => locale.languageCode == 'ar' ? 'البلد' : 'Country';
  String get enterCountry => locale.languageCode == 'ar' ? 'أدخل بلدك' : 'Enter your country';
  String get countryRequired => locale.languageCode == 'ar' ? 'البلد مطلوب' : 'Country is required';
  String get parentalInformation => locale.languageCode == 'ar' ? 'معلومات ولي الأمر' : 'Parent/Guardian Information';
  String get parentGuardianName => locale.languageCode == 'ar' ? 'اسم ولي الأمر' : 'Parent/Guardian Name';
  String get enterParentName => locale.languageCode == 'ar' ? 'أدخل اسم ولي الأمر' : 'Enter parent/guardian name';
  String get parentNameRequired => locale.languageCode == 'ar' ? 'اسم ولي الأمر مطلوب' : 'Parent/Guardian name is required';
  String get parentGuardianEmail => locale.languageCode == 'ar' ? 'البريد الإلكتروني لولي الأمر' : 'Parent/Guardian Email';
  String get enterParentEmail => locale.languageCode == 'ar' ? 'أدخل البريد الإلكتروني لولي الأمر' : 'Enter parent/guardian email';
  String get parentEmailRequired => locale.languageCode == 'ar' ? 'البريد الإلكتروني لولي الأمر مطلوب' : 'Parent/Guardian email is required';
  String get parentInfoRequired => locale.languageCode == 'ar' ? 'معلومات ولي الأمر مطلوبة للقاصرين' : 'Parent/Guardian information is required for minors';
  String get register => locale.languageCode == 'ar' ? 'تسجيل' : 'Register';
  String get parentalConsentRequired => locale.languageCode == 'ar' ? 'موافقة ولي الأمر مطلوبة' : 'Parental Consent Required';
  String get parentalConsentMessage => locale.languageCode == 'ar' ? 'نظراً لأنك دون سن 18، أرسلنا طلب موافقة إلى ولي أمرك.' : 'Since you are under 18, we have sent a consent request to your parent/guardian.';
  String get consentSentTo => locale.languageCode == 'ar' ? 'تم إرسال الموافقة إلى' : 'Consent sent to';
  String get ok => locale.languageCode == 'ar' ? 'حسناً' : 'OK';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
