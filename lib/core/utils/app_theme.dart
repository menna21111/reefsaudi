import 'app_color.dart';
import 'app_color_scheme.dart';

/// مصدر ألوان التطبيق (فاتح / داكن) — للتبديل عبر [ThemeBloc].
///
/// لا تضع [ThemeData] هنا؛ تعريف شكل الثيم في
/// `core/theme/light_theme_data.dart` و `dark_theme_data.dart`.
abstract final class AppTheme {
  static final AppColorScheme light = LightAppColor();
  static final AppColorScheme dark = DarkAppColor();

  static AppColorScheme of(bool isDark) => isDark ? dark : light;
}
