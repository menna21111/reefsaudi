import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/auth/presination/screans/login_screan.dart';
import '../funcation.dart';
import '../services/service_locator.dart';
import '../utils/app_theme_context.dart';
import '../widgets/applogo.dart';
import 'navigation.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entryController.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    var isLoggedIn = false;

    try {
      final results = await Future.wait([
        _restoreSession(),
        Future<void>.delayed(const Duration(milliseconds: 2500)),
      ]);
      isLoggedIn = results[0] as bool;
    } catch (_) {
      isLoggedIn = false;
    }

    if (!mounted) return;

    AppFunctions.navigateToAndFinish(
      context,
      isLoggedIn ? BottomNavigation() : const LoginScrean(),
    );
  }

  Future<bool> _restoreSession() async {
    return sl<AuthRepositoryImpl>().restoreSession();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColorsRead;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_entryController, _pulseController]),
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value * _pulseAnimation.value,
                child: child,
              ),
            );
          },
          child: Applogo(height: 120.h, width: 100.w),
        ),
      ),
    );
  }
}
