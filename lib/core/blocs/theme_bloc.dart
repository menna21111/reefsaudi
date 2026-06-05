import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/app_color_scheme.dart';
import '../utils/app_theme.dart';
import '../utils/cache_helper.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState()) {
    on<DarkThemeEvent>(_darkTheme);
    on<LightThemeEvent>(_lightTheme);
    _loadTheme();
  }

  void _loadTheme() {
    final bool? isDark = CacheHelper.getData(key: 'isDark');
    if (isDark != null && isDark) {
      add(DarkThemeEvent(savePreference: false));
    }
  }

  FutureOr<void> _darkTheme(
    DarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (event.savePreference) {
      await CacheHelper.saveData(key: 'isDark', value: true);
    }
    emit(state.copyWith(isDark: true, appColor: AppTheme.dark));
  }

  FutureOr<void> _lightTheme(
    LightThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (event.savePreference) {
      await CacheHelper.saveData(key: 'isDark', value: false);
    }
    emit(state.copyWith(isDark: false, appColor: AppTheme.light));
  }
}
