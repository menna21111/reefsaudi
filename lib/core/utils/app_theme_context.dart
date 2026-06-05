import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme_bloc.dart';
import 'app_color_scheme.dart';
import 'app_theme.dart';

extension AppThemeContext on BuildContext {
  /// ألوان الوضع الحالي (فاتح/داكن) من [AppTheme].
  AppColorScheme get appColors => AppTheme.of(watch<ThemeBloc>().state.isDark);

  AppColorScheme get appColorsRead => AppTheme.of(read<ThemeBloc>().state.isDark);
}
