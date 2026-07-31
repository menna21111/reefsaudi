import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Global logger wrapper for the entire app.
///
/// Uses the `logger` package under the hood and automatically
/// disables logging in release builds.
class AppLogger {
  factory AppLogger() => _instance;
  AppLogger._internal()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 100,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

  static final AppLogger _instance = AppLogger._internal();

  final Logger _logger;

  static bool get _enabled => kDebugMode;

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_enabled) {
      return;
    }
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_enabled) {
      return;
    }
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_enabled) {
      return;
    }
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!_enabled) {
      return;
    }
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
