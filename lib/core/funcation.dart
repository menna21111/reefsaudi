import 'dart:io';


import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';

import 'dart:ui' as ui;

import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import 'utils/app_color.dart';
import 'utils/app_font.dart';

class AppFunctions {
  static String formatArabicDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);

    return DateFormat('d MMMM yyyy', 'ar').format(dateTime);
  }

  static String reverseString(String originalString) {
    List<String> charList = originalString.split('');
    List<String> reversedList = charList.reversed.toList();
    String reversedString = reversedList.join();

    debugPrint('Original String: $originalString');
    debugPrint('Reversed String: $reversedString');

    return reversedString;
  }

  static void showsToast(
    String text,
    Color color,
    BuildContext context, {
    int seconds = 5,
  }) {
    showToast(
      text,
      context: context,
      backgroundColor: color,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: StyledToastPosition.top,
      animDuration: const Duration(seconds: 2),
      duration: Duration(seconds: seconds),
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInOutCirc,
    );
  }

  static void showSuccessToast(
    BuildContext context,
    String text, {
    int seconds = 3,
  }) {
    showToastWidget(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: const Color(0xFFDFF6E5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF34C759),
                  width: 2.2.w,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                color: const Color(0xFF34C759),
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            RobotoText(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.kGlowColor,
            ),
          ],
        ),
      ),
      context: context,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: const StyledToastPosition(
        align: Alignment.topCenter,
        offset: 80.0,
      ),
      animDuration: const Duration(milliseconds: 500),
      duration: Duration(seconds: seconds),
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );
  }

  static String prettyTime(String timeString) {
    DateTime time = DateTime.parse(timeString);

    String formattedTime = DateFormat('h:mm a').format(time);

    return formattedTime;
  }

  static String prettyDate(String dateString) {
    DateTime date = DateTime.parse(dateString);

    String formattedTime = DateFormat('MM-dd-yyyy').format(date);

    return formattedTime;
  }

  String getTodayDate() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return today;
  }

  static String convertTo12Hour(String time24) {
    try {
      DateTime parsedTime = DateFormat("HH:mm:ss").parseLoose(time24);
      return DateFormat("h:mm a", 'en_US').format(parsedTime);
    } catch (e) {
      try {
        DateTime parsedTime = DateFormat("HH:mm").parseLoose(time24);
        return DateFormat("h:mm a", 'en_US').format(parsedTime);
      } catch (e) {
        return time24;
      }
    }
  }

  static bool pickerActive = false;

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }

  static Future<void> navigateTo(
    BuildContext context,
    Widget screen,
    PageTransitionType type,
  ) async {
    await (Platform.isIOS
        ? Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => screen))
        : Navigator.of(context).push(
            PageTransition(
              child: screen,
              type: type,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 200),
            ),
          ));
  }

  static void navigateToAndReplacement(BuildContext context, Widget screen) {
    Platform.isIOS
        ? Navigator.of(
            context,
          ).pushReplacement(CupertinoPageRoute(builder: (context) => screen))
        : Navigator.of(context).pushReplacement(
            PageTransition(
              child: screen,
              type: PageTransitionType.rightToLeft,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
            ),
          );
  }

  static void navigateToAndFinish(BuildContext context, Widget screen) {
    Platform.isIOS
        ? Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => screen),
            (route) => false,
          )
        : Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
              child: screen,
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
            ),
            (route) => false,
          );
  }

  static void popThenNavigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.of(context).push(
      PageTransition(
        child: screen,
        type: PageTransitionType.rightToLeft,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  static String convertToArabic(int number) {
    List<String> arabicDigits = [
      '٠',
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩',
    ];

    String result = '';
    String numberStr = number.toString();

    for (int i = 0; i < numberStr.length; i++) {
      int digit = int.parse(numberStr[i]);
      result += arabicDigits[digit];
    }

    return result;
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final Uri url = Uri.parse(googleUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not open the map.';
    }
  }
}
