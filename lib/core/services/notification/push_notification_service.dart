import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';
import '../pmo_device_service.dart';
import '../service_locator.dart';
import 'notification_manager.dart';

/// Top-level background handler (must not be a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint(
    '🔔 Background message: ${message.notification?.title} — '
    '${message.notification?.body}',
  );
}

/// FCM + local notifications setup (mirrors Qarib_App behaviour).
class PushNotificationService {
  PushNotificationService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'reefsaudia_channel',
    'Reefsaudia Notifications',
    description: 'Push notifications for Reefsaudia',
    importance: Importance.max,
  );

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  /// Initializes Firebase, local notifications, FCM listeners, and stores token.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase initialized (${Firebase.app().options.projectId})');
    } catch (e, st) {
      debugPrint('❌ Firebase init failed: $e');
      debugPrint('$st');
      return;
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _setupLocalNotifications();
    await _requestPermissions();
    _listenTokenRefresh();
    _setupMessageHandlers();
    await _checkInitialMessage();

    // Don't block app start — APNS often arrives a few seconds after launch on iOS.
    unawaited(_persistFcmToken());

    _initialized = true;
  }

  static Future<void> _setupLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        _onNotificationOpened();
      },
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_channel);
  }

  static Future<void> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

    if (Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Waits until iOS has an APNS device token, then fetches FCM token.
  static Future<void> _persistFcmToken({int maxAttempts = 12}) async {
    final messaging = FirebaseMessaging.instance;

    if (Platform.isIOS && _isIosSimulator) {
      debugPrint(
        'ℹ️ iOS Simulator detected — APNS/FCM tokens are unavailable. '
        'Run on a physical iPhone to get a push token.',
      );
      return;
    }

    if (Platform.isIOS) {
      final apnsReady = await _waitForApnsToken(messaging);
      if (!apnsReady) {
        debugPrint(
          '⚠️ APNS token still missing after retries. '
          'Use a real device (not Simulator) and ensure Push capability + '
          'APS environment entitlement are enabled.',
        );
        return;
      }
    }

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final token = await messaging.getToken();
        if (token != null && token.isNotEmpty) {
          await sl<PmoDeviceService>().setFirebaseToken(token);
          debugPrint('✅ FCM token saved (${token.substring(0, 12)}…)');
          return;
        }
        debugPrint('⚠️ FCM token null (attempt $attempt/$maxAttempts)');
      } catch (e) {
        debugPrint('⚠️ FCM token error (attempt $attempt/$maxAttempts): $e');
      }
      await Future<void>.delayed(Duration(seconds: attempt.clamp(1, 5)));
    }
  }

  static bool get _isIosSimulator {
    return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME') ||
        Platform.environment.containsKey('SIMULATOR_UDID');
  }

  static Future<bool> _waitForApnsToken(
    FirebaseMessaging messaging, {
    int maxAttempts = 15,
  }) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final apns = await messaging.getAPNSToken();
        if (apns != null && apns.isNotEmpty) {
          debugPrint('✅ APNS token ready (attempt $attempt)');
          return true;
        }
      } catch (e) {
        debugPrint('⚠️ getAPNSToken error (attempt $attempt): $e');
      }
      debugPrint(
        '⏳ Waiting for APNS token… ($attempt/$maxAttempts)',
      );
      await Future<void>.delayed(Duration(seconds: attempt.clamp(1, 3)));
    }
    return false;
  }

  static void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await sl<PmoDeviceService>().setFirebaseToken(token);
      debugPrint('🔄 FCM token refreshed');
    });
  }

  static void _setupMessageHandlers() {
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint(
        '📩 Foreground: ${message.notification?.title} — '
        '${message.notification?.body}',
      );
      final enabled = await NotificationManager.isNotificationsEnabled();
      if (enabled) {
        await showLocalNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('👆 Notification opened: ${message.notification?.title}');
      _onNotificationOpened(message: message);
    });
  }

  static Future<void> _checkInitialMessage() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      debugPrint('🚀 Opened from terminated via notification');
      // Defer until navigator is ready.
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        _onNotificationOpened(message: initial);
      });
    }
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title ?? 'إشعار جديد',
      body: message.notification?.body ?? '',
      notificationDetails: details,
      payload: message.data['route']?.toString() ?? 'notifications',
    );
  }

  /// Hook for notification taps. Extend when a notifications screen exists.
  static void _onNotificationOpened({RemoteMessage? message}) {
    debugPrint('📬 Notification opened payload: ${message?.data}');
  }

  /// Call before login/refresh so `firbaseTokin` is not empty when possible.
  static Future<String> refreshAndPersistToken() async {
    if (!_initialized) {
      return sl<PmoDeviceService>().getFirebaseToken();
    }

    if (Platform.isIOS && _isIosSimulator) {
      debugPrint(
        'ℹ️ Simulator: FCM token unavailable — login will send empty firbaseTokin',
      );
      return '';
    }

    try {
      if (Platform.isIOS) {
        final apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns == null || apns.isEmpty) {
          debugPrint('⚠️ APNS not ready yet — using cached FCM token if any');
          return sl<PmoDeviceService>().getFirebaseToken();
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await sl<PmoDeviceService>().setFirebaseToken(token);
        debugPrint('✅ FCM token ready for login (${token.substring(0, 12)}…)');
        return token;
      }
    } catch (e) {
      debugPrint('⚠️ refreshAndPersistToken failed: $e');
    }

    return sl<PmoDeviceService>().getFirebaseToken();
  }
}
