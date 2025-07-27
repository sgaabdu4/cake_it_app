// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => '🎂تطبيق الكيك🍰';

  @override
  String get notFound => 'غير موجود';

  @override
  String get viewNotFound => 'الصفحة غير موجودة';

  @override
  String failedToRefresh({required String error}) {
    return 'فشل في التحديث: $error';
  }

  @override
  String get errorLoadingCakes => 'خطأ في تحميل الكعك';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get failedToRefreshCakes => 'فشل في تحديث الكعك';

  @override
  String get cakeDetails => 'تفاصيل الكعكة';

  @override
  String get noCakeData => 'لا توجد بيانات كعكة متاحة';

  @override
  String get noDescriptionAvailable => 'لا يوجد وصف متاح';

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get systemTheme => 'مظهر النظام';

  @override
  String get lightTheme => 'المظهر الفاتح';

  @override
  String get darkTheme => 'المظهر الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get systemLanguage => 'لغة النظام';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get requestTimeout => 'انتهت مهلة الطلب';

  @override
  String serverError({required int statusCode}) {
    return 'خطأ في الخادم: $statusCode';
  }

  @override
  String networkError({required String error}) {
    return 'خطأ في الشبكة: $error';
  }

  @override
  String failedToFetchCakes({required String error}) {
    return 'فشل في جلب الكعك: $error';
  }

  @override
  String get description => 'الوصف';
}
