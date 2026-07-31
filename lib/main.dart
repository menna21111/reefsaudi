import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'core/navigation/app_navigator.dart';
import 'core/blocs/theme_bloc.dart';
import 'core/config/splash_screen.dart';
import 'core/permissions/permission_cubit.dart';
import 'core/network/dio_helper.dart';
import 'core/services/app_locle.dart';
import 'core/services/service_locator.dart';
import 'core/theme/dark_theme_data.dart';
import 'core/theme/light_theme_data.dart';
import 'core/utils/cache_helper.dart';
import 'core/utils/responsive.dart';
import 'features/chat/core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("🚀 Starting app initialization...");

  await EasyLocalization.ensureInitialized();
  ensureChatConfig();
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ThemeBloc>()),
          BlocProvider(create: (_) => sl<PermissionCubit>()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Phone: 360x800 — Tablet/iPad: 768x1024 so .w/.sp don't overscale.
      designSize: appDesignSize(),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,

              // ✅ Localization
              localizationsDelegates: [
                ...context.localizationDelegates,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                SfGlobalLocalizations.delegate,
              ],
              supportedLocales: context.supportedLocales,
              locale: context.locale,

              // ✅ Theme
              theme: lightThemeData,
              darkTheme: darkThemeData,
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,

              builder: (context, child) {
                final direction = context.locale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr;
                return StyledToast(
                  child: Directionality(
                    textDirection: direction,
                    child: child ?? const SizedBox.shrink(),
                  ),
                );
              },

              // ✅ FIX: IMPORTANT (prevents your crash)
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
