// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:collectorapp/core/services/notification/notification_manager.dart';
// import 'package:collectorapp/core/utils/app_color.dart';
// import 'package:collectorapp/core/utils/app_font.dart';
// import 'package:collectorapp/core/utils/app_theme.dart';

// class PushNotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   void initialize() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       bool isEnabled = await NotificationManager.isNotificationsEnabled();
//       if (isEnabled) {
//         if (message.notification != null) {
//           print("Received notification: ${message.notification?.title}");
//           print("Title: ${message.notification?.title}");
//           print("Body: ${message.notification?.body}");

//           Get.snackbar(
//             "", "",
//             // "${message.notification?.title}", "${message.notification?.body}",
//             titleText: CairoText(
//               text: "${message.notification?.title}",
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: AppColor.kPrimaryColor,
//             ),
//             messageText: PoppinsText(
//               text: "${message.notification?.body}",
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: AppColor.kPrimaryColor,
//             ),
//             snackPosition: SnackPosition.TOP,
//             backgroundColor: AppColor.kBgColor,
//             duration: Duration(seconds: 3),
//             borderColor: AppColor.kPrimaryColor, borderWidth: 0.5.w,
//             borderRadius: 8.r,
//           );
//         }
//       } else {
//         debugPrint("Notifications are disabled.");
//       }
//     });
//   }
// }
