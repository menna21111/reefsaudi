import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:reefsaudia/features/auth/presination/screans/login_screan.dart';

import 'core/blocs/theme_bloc.dart';
import 'core/config/navigation.dart';
import 'core/network/dio_helper.dart';
import 'core/services/app_locle.dart';
import 'core/services/service_locator.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/cache_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("🚀 Starting app initialization...");

  await EasyLocalization.ensureInitialized();
  ServiceLocator().init();
  await CacheHelper.init();
  await DioHelper.init();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("⚠️ Dotenv not found: $e");
  }

  runApp(
    EasyLocalization(
      supportedLocales: AppLocale.supportedLocales,
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      child: BlocProvider(create: (_) => sl<ThemeBloc>(), child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,

              // ✅ Localization
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,

              // ✅ Theme
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,

              // ✅ FIX: IMPORTANT (prevents your crash)
              home: BottomNavigation(),
            );
          },
        );
      },
    );
  }
}
