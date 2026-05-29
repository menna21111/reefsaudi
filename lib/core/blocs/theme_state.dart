part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final bool isDark;
  final ThemeData themeData; // to be deleted
  final AppColorScheme appColor;

  ThemeState({this.isDark = false, ThemeData? themeData, AppColorScheme? appColor})
      : themeData = themeData ?? AppTheme.lightTheme,
        appColor = appColor ?? LightAppColor();

  ThemeState copyWith({
    bool? isDark,
    ThemeData? themeData,
    AppColorScheme? appColor,
  }) {
    return ThemeState(
      isDark: isDark ?? this.isDark,
      themeData: themeData ?? (isDark ?? this.isDark ? AppTheme.darkTheme : AppTheme.lightTheme),
      appColor: appColor ?? (isDark ?? this.isDark ? DarkAppColor() : LightAppColor()),
    );
  }

  @override
  List<Object> get props => [isDark, themeData, appColor];
}
