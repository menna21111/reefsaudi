import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/theme_bloc.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            state.isDark ? Icons.light_mode : Icons.dark_mode,
            color: state.isDark ? Colors.orange : Colors.black,
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(
                  state.isDark
                      ? const LightThemeEvent()
                      : const DarkThemeEvent(),
                );
          },
        );
      },
    );
  }
}
