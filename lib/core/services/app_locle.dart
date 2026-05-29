import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'service_locator.dart';
import 'storage_service/storage.dart';


class AppLocale {
  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
    Locale('bn'),
    Locale('hi'),
    Locale('ur'),
  ];

  static const String _localeKey = 'app_locale';

  static Future<void> changeLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    final storage = sl<StorageService>();
    await storage.write(_localeKey, locale.languageCode);
  }

  static Future<String> getSavedLanguage() async {
    try {
      final storage = sl<StorageService>();
      String lang = await storage.read(_localeKey);
      if (lang.isNotEmpty) {
        return lang;
      }
    } catch (_) {}

    try {
      String deviceLang = ui.PlatformDispatcher.instance.locale.languageCode;
      if (supportedLocales.any((l) => l.languageCode == deviceLang)) {
        return deviceLang;
      }
    } catch (_) {}
    return 'en'; // default fallback
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'bn':
        return 'বাংলা';
      case 'hi':
        return 'हिन्दी';
      case 'ur':
        return 'اردو';
      default:
        return 'English';
    }
  }
}
