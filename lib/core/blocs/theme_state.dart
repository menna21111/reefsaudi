part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final bool isDark;
  final AppColorScheme appColor;

  ThemeState({this.isDark = false, AppColorScheme? appColor})
      : appColor = appColor ?? AppTheme.of(isDark);

  ThemeState copyWith({bool? isDark, AppColorScheme? appColor}) {
    final dark = isDark ?? this.isDark;
    return ThemeState(
      isDark: dark,
      appColor: appColor ?? AppTheme.of(dark),
    );
  }

  @override
  List<Object> get props => [isDark, appColor];
}
