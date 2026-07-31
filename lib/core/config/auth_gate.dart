import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/data/models/profile_model.dart';
import '../../features/auth/presination/screans/login_screan.dart';
import '../permissions/permission_cubit.dart';
import '../services/service_locator.dart';
import '../utils/app_theme_context.dart';
import 'navigation.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

/// Restores session + cached permissions, then routes to home or login.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<bool> _sessionFuture;

  @override
  void initState() {
    super.initState();
    _sessionFuture = _restoreSession();
  }

  Future<bool> _restoreSession() async {
    try {
      return await sl<AuthRepositoryImpl>().restoreSession();
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _sessionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: context.appColorsRead.kBgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: context.appColorsRead.kPrimaryColor,
              ),
            ),
          );
        }

        final isLoggedIn = snapshot.data == true;
        if (!isLoggedIn) {
          return const LoginScrean();
        }

        return BlocBuilder<PermissionCubit, ProfileModel?>(
          builder: (context, profile) {
            if (profile == null) {
              return const LoginScrean();
            }

            return const BottomNavigation();
          },
        );
      },
    );
  }
}
