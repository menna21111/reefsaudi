import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presination/screans/login_screan.dart';
import '../services/service_locator.dart';
import '../utils/app_theme_context.dart';
import 'navigation.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

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
    return sl<AuthRepositoryImpl>().restoreSession();
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

        return snapshot.data == true
            ? LoginScrean()
            : const LoginScrean();
      },
    );
  }
}
