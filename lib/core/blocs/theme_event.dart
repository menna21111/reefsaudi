part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class DarkThemeEvent extends ThemeEvent {
  final bool savePreference;
  const DarkThemeEvent({this.savePreference = true});

  @override
  List<Object> get props => [savePreference];
}

class LightThemeEvent extends ThemeEvent {
  final bool savePreference;
  const LightThemeEvent({this.savePreference = true});

  @override
  List<Object> get props => [savePreference];
}
