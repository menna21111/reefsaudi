import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc.dart';
import 'app_color_scheme.dart';
import 'app_theme.dart';

/// اتجاه ومحاذاة الفورمات حسب لغة التطبيق (من Directionality).

abstract final class FormLayout {
  static TextDirection directionOf(BuildContext context) =>
      Directionality.of(context);

  static TextAlign alignOf(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl
          ? TextAlign.right
          : TextAlign.left;

  static AlignmentDirectional contentAlignOf(BuildContext context) =>
      AlignmentDirectional.centerStart;
}

/// @deprecated استخدم Directionality من MaterialApp — لا تلف الشاشة بـ RTL ثابت.
class ArabicFormScope extends StatelessWidget {
  const ArabicFormScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

extension AppThemeContext on BuildContext {
  AppColorScheme get appColors => AppTheme.of(watch<ThemeBloc>().state.isDark);

  AppColorScheme get appColorsRead => AppTheme.of(read<ThemeBloc>().state.isDark);
}

extension LocaleLayoutContext on BuildContext {
  bool get isRtl => locale.languageCode == 'ar';

  TextDirection get layoutDirection => FormLayout.directionOf(this);

  TextAlign get fieldTextAlign => FormLayout.alignOf(this);

  AlignmentDirectional get fieldAlign => FormLayout.contentAlignOf(this);
}
