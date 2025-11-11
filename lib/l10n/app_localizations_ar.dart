// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'سكاوت مينا';

  @override
  String get welcome => 'مرحباً بك في سكاوت مينا';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get continueButton => 'متابعة';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get submit => 'إرسال';

  @override
  String get confirm => 'تأكيد';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get close => 'إغلاق';

  @override
  String get ok => 'حسناً';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get loading => 'جار التحميل...';

  @override
  String get pleaseWait => 'يرجى الانتظار...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String get phoneAuth => 'المصادقة بالهاتف';

  @override
  String get enterPhoneNumber => 'أدخل رقم هاتفك';

  @override
  String get phoneNumberHint => 'رقم الهاتف';

  @override
  String get sendOtp => 'إرسال الرمز';

  @override
  String get verifyOtp => 'تحقق من الرمز';

  @override
  String get otpVerification => 'التحقق من الرمز';

  @override
  String get enterOtp => 'أدخل الرمز المكون من 6 أرقام المرسل إلى';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendIn(int seconds) {
    return 'إعادة الإرسال بعد $seconds ثانية';
  }

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get roleSelection => 'اختر دورك';

  @override
  String get imAPlayer => 'أنا لاعب';

  @override
  String get imAScout => 'أنا كشاف';

  @override
  String get playerDescription => 'اعرض موهبتك واكتشفها الكشافون';

  @override
  String get scoutDescription =>
      'اكتشف لاعبي كرة القدم الموهوبين في منطقة الشرق الأوسط وشمال أفريقيا';

  @override
  String get registration => 'التسجيل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get country => 'البلد';

  @override
  String get age => 'العمر';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get playerProfile => 'ملف اللاعب';

  @override
  String get scoutProfile => 'ملف الكشاف';

  @override
  String get createProfile => 'إنشاء الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get viewProfile => 'عرض الملف الشخصي';

  @override
  String get profilePhoto => 'صورة الملف الشخصي';

  @override
  String get uploadPhoto => 'تحميل صورة';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get basicInformation => 'المعلومات الأساسية';

  @override
  String get footballInformation => 'معلومات كرة القدم';

  @override
  String get contactInformation => 'معلومات الاتصال';

  @override
  String get parentInformation => 'معلومات ولي الأمر';

  @override
  String get height => 'الطول (سم)';

  @override
  String get weight => 'الوزن (كجم)';

  @override
  String get dominantFoot => 'القدم المفضلة';

  @override
  String get leftFoot => 'اليسرى';

  @override
  String get rightFoot => 'اليمنى';

  @override
  String get bothFeet => 'كلاهما';

  @override
  String get position => 'المركز';

  @override
  String get currentClub => 'النادي الحالي';

  @override
  String get jerseyNumber => 'رقم القميص';

  @override
  String get yearsPlaying => 'سنوات اللعب';

  @override
  String get goalkeeper => 'حارس مرمى';

  @override
  String get defender => 'مدافع';

  @override
  String get midfielder => 'لاعب وسط';

  @override
  String get forward => 'مهاجم';

  @override
  String get photos => 'الصور';

  @override
  String get videos => 'الفيديوهات';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get analytics => 'التحليلات';

  @override
  String get gallery => 'المعرض';

  @override
  String get uploadPhotos => 'تحميل الصور';

  @override
  String get uploadVideo => 'تحميل فيديو';

  @override
  String get addPhotos => 'إضافة صور';

  @override
  String get selectPhotos => 'اختر الصور';

  @override
  String get videoTitle => 'عنوان الفيديو';

  @override
  String get videoDescription => 'وصف الفيديو';

  @override
  String get processing => 'جار المعالجة';

  @override
  String get videoProcessing => 'جار معالجة الفيديو';

  @override
  String get videoReady => 'الفيديو جاهز';

  @override
  String get videoFailed => 'فشلت معالجة الفيديو';

  @override
  String get matchesPlayed => 'المباريات المشاركة';

  @override
  String get goals => 'الأهداف';

  @override
  String get assists => 'التمريرات الحاسمة';

  @override
  String get yellowCards => 'البطاقات الصفراء';

  @override
  String get redCards => 'البطاقات الحمراء';

  @override
  String get minutesPlayed => 'الدقائق المشاركة';

  @override
  String get season => 'الموسم';

  @override
  String get search => 'بحث';

  @override
  String get searchPlayers => 'البحث عن اللاعبين';

  @override
  String get filters => 'التصفية';

  @override
  String get applyFilters => 'تطبيق التصفية';

  @override
  String get clearFilters => 'مسح التصفية';

  @override
  String get ageRange => 'نطاق العمر';

  @override
  String get heightRange => 'نطاق الطول';

  @override
  String get savedSearches => 'عمليات البحث المحفوظة';

  @override
  String get saveSearch => 'حفظ البحث';

  @override
  String get searchName => 'اسم البحث';

  @override
  String get executeSearch => 'تنفيذ البحث';

  @override
  String get settings => 'الإعدادات';

  @override
  String get account => 'الحساب';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get language => 'اللغة';

  @override
  String get theme => 'المظهر';

  @override
  String get about => 'حول';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get privacySettings => 'إعدادات الخصوصية';

  @override
  String get profileVisibility => 'رؤية الملف الشخصي';

  @override
  String get publicProfile => 'عام';

  @override
  String get scoutsOnly => 'الكشافون فقط';

  @override
  String get privateProfile => 'خاص';

  @override
  String get contactVisibility => 'رؤية معلومات الاتصال';

  @override
  String get showEmail => 'إظهار البريد الإلكتروني';

  @override
  String get showPhone => 'إظهار رقم الهاتف';

  @override
  String get allowMessages => 'السماح برسائل من الكشافين';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get profileViews => 'مشاهدات الملف الشخصي';

  @override
  String get newMessages => 'الرسائل الجديدة';

  @override
  String get moderationUpdates => 'تحديثات المراجعة';

  @override
  String get systemAnnouncements => 'الإعلانات النظامية';

  @override
  String get parentConsent => 'موافقة ولي الأمر';

  @override
  String get parentName => 'اسم ولي الأمر';

  @override
  String get parentEmail => 'بريد ولي الأمر الإلكتروني';

  @override
  String get parentPhone => 'هاتف ولي الأمر';

  @override
  String get consentRequired =>
      'مطلوب موافقة ولي الأمر للمستخدمين الأقل من 18 عاماً';

  @override
  String get awaitingConsent => 'في انتظار موافقة ولي الأمر';

  @override
  String get moderationPending => 'قيد المراجعة';

  @override
  String get moderationApproved => 'تمت الموافقة';

  @override
  String get moderationRejected => 'مرفوض';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get tryAgain => 'يرجى المحاولة مرة أخرى';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get serverError => 'خطأ في الخادم. يرجى المحاولة لاحقاً';

  @override
  String get authenticationError =>
      'خطأ في المصادقة. يرجى تسجيل الدخول مرة أخرى';

  @override
  String get validationError => 'يرجى التحقق من إدخالك';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'عنوان بريد إلكتروني غير صحيح';

  @override
  String get invalidPhone => 'رقم هاتف غير صحيح';

  @override
  String get welcomeToScoutMena => 'مرحباً بك في سكاوت مينا';

  @override
  String get enterPhoneToGetStarted => 'أدخل رقم هاتفك للبدء';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get pleaseAcceptTerms => 'يرجى قبول الشروط والأحكام';

  @override
  String get iAgreeToThe => 'أوافق على';

  @override
  String get and => 'و';

  @override
  String get sendOTP => 'إرسال رمز التحقق';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get orContinueWith => 'أو المتابعة مع';

  @override
  String get continueWithGoogle => 'المتابعة مع Google';

  @override
  String get continueWithApple => 'المتابعة مع Apple';

  @override
  String get verifyPhoneNumber => 'تحقق من رقم الهاتف';

  @override
  String get weHaveSentOTPTo => 'لقد أرسلنا رمز التحقق إلى';

  @override
  String get otpRequired => 'يرجى إدخال رمز التحقق المكون من 6 أرقام';

  @override
  String get resendCodeIn => 'إعادة إرسال الرمز في';

  @override
  String get seconds => 'ثانية';

  @override
  String get verify => 'تحقق';

  @override
  String get otpResent => 'تم إعادة إرسال رمز التحقق بنجاح';

  @override
  String get selectYourRole => 'اختر دورك';

  @override
  String get chooseAccountType => 'اختر نوع حسابك للمتابعة';

  @override
  String get player => 'لاعب';

  @override
  String get playerRoleDescription =>
      'أنشئ ملفك الشخصي، اعرض موهبتك، واحصل على فرصة الاكتشاف من قبل الكشافة';

  @override
  String get scout => 'كشاف';

  @override
  String get scoutRoleDescription =>
      'ابحث عن اللاعبين الموهوبين، احفظ عمليات البحث، واكتشف نجم كرة القدم القادم';

  @override
  String get pleaseSelectRole => 'يرجى اختيار دور للمتابعة';

  @override
  String get continueText => 'متابعة';

  @override
  String get completeYourProfile => 'أكمل ملفك الشخصي';

  @override
  String get tellUsAboutYourself => 'أخبرنا عن نفسك';

  @override
  String get enterFullName => 'أدخل اسمك الكامل';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get enterEmail => 'أدخل عنوان بريدك الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get selectDateOfBirth => 'اختر تاريخ ميلادك';

  @override
  String get dateOfBirthRequired => 'تاريخ الميلاد مطلوب';

  @override
  String get minorAccountNotice => 'أنت دون سن 18. معلومات ولي الأمر مطلوبة.';

  @override
  String get enterCountry => 'أدخل بلدك';

  @override
  String get countryRequired => 'البلد مطلوب';

  @override
  String get parentalInformation => 'معلومات ولي الأمر';

  @override
  String get parentGuardianName => 'اسم ولي الأمر';

  @override
  String get enterParentName => 'أدخل اسم ولي الأمر';

  @override
  String get parentNameRequired => 'اسم ولي الأمر مطلوب';

  @override
  String get parentGuardianEmail => 'البريد الإلكتروني لولي الأمر';

  @override
  String get enterParentEmail => 'أدخل البريد الإلكتروني لولي الأمر';

  @override
  String get parentEmailRequired => 'البريد الإلكتروني لولي الأمر مطلوب';

  @override
  String get parentInfoRequired => 'معلومات ولي الأمر مطلوبة للقاصرين';

  @override
  String get register => 'تسجيل';

  @override
  String get parentalConsentRequired => 'موافقة ولي الأمر مطلوبة';

  @override
  String get parentalConsentMessage =>
      'نظراً لأنك دون سن 18، أرسلنا طلب موافقة إلى ولي أمرك.';

  @override
  String get consentSentTo => 'تم إرسال الموافقة إلى';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get lightMode => 'فاتح';

  @override
  String get darkMode => 'داكن';

  @override
  String get systemMode => 'النظام';

  @override
  String get version => 'الإصدار';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get share => 'مشاركة';

  @override
  String get report => 'الإبلاغ';
}
