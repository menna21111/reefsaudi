
// import 'package:flutter/material.dart';

// import 'navigation.dart';

// class AppRoutes {
//   static Route onGenerateRoutes(RouteSettings settings) {
//     switch (settings.name) {
//       case kSplashScreen:
//         return _materialRoute(const SplashScrean(), settings);

//       case kBottomNavigation:
//         return _materialRoute(const BottomNavigation(), settings);

//       case kLoginScreen:
//         return _materialRoute(const LoginScrean(), settings);

//       case kForgotPasswordPhoneScreen:
//         return _materialRoute(const ForgotPasswordPhoneScrean(), settings);

//       case kVerifyScreen:
//         final args = settings.arguments;
//         final phone = args is VerifyScreenArgs
//             ? args.phone
//             : (args is String? ? args ?? '' : '');
//         final isForgotPassword = args is VerifyScreenArgs
//             ? args.isForgotPassword
//             : false;
//         return _materialRoute(
//           VerifyScrean(phone: phone, isForgotPassword: isForgotPassword),
//           settings,
//         );

//       case kVerifySuccessScreen:
//         return _materialRoute(const VerifySuccessScrean(), settings);
//       case kONboardingscrean:
//         return _materialRoute(const OnBoardingScrean(), settings);

//       case kSetNewPasswordScreen:
//         final args = settings.arguments;
//         String phone = '';
//         String? code;
//         if (args is SetNewPasswordArgs) {
//           phone = args.phone;
//           code = args.code;
//         } else if (args is String) {
//           phone = args;
//         }
//         return _materialRoute(
//             SetNewPasswordScrean(phone: phone, code: code), settings);

//       case kNewPasswordSuccessScreen:
//         return _materialRoute(const NewPasswordSuccessScrean(), settings);

//       default:
//         return _materialRoute(const SplashScrean(), settings);
//     }
//   }

//   static Route<dynamic> _materialRoute(Widget view, RouteSettings settings) {
//     return MaterialPageRoute(builder: (_) => view, settings: settings);
//   }
// }

// const String kSplashScreen = "/splash";
// const String kBottomNavigation = "/bottomNavigation";
// const String kLoginScreen = "/login";
// const String kONboardingscrean = "/onboarding";
// const String kForgotPasswordPhoneScreen = "/forgot-password-phone";
// const String kVerifyScreen = "/verify";
// const String kVerifySuccessScreen = "/verify-success";
// const String kSetNewPasswordScreen = "/set-new-password";
// const String kNewPasswordSuccessScreen = "/new-password-success";
// const String kAppRoot = "/";
