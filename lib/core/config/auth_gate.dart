import 'package:flutter/material.dart';

import '../../features/auth/presination/screans/login_screan.dart';
import '../services/service_locator.dart';
import '../services/token_service/token_storage.dart';
import 'navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: sl<TokenStorage>().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        final token = snapshot.data;
        final hasToken = token != null && token.isNotEmpty;
        return hasToken ? LoginScrean() : const LoginScrean();
      },
    );
  }
}
