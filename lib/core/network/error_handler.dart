import 'package:dio/dio.dart';

import '../utils/app_string.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.unKnown.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectionTimeout.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();
      case DioExceptionType.badCertificate:
        return DataSource.badCertificate.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null) {
          // Extract message from response body if available
          String message = error.response?.data is Map
              ? (error.response?.data['message'] ??
                  error.response?.statusMessage ??
                  AppString.unKnownError)
              : (error.response?.statusMessage ?? AppString.unKnownError);

          return Failure(0, message);
        } else {
          return DataSource.unKnown.getFailure();
        }

      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      case DioExceptionType.connectionError:
        return DataSource.connectionError.getFailure();
      case DioExceptionType.unknown:
        return DataSource.unKnown.getFailure();
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

enum DataSource {
  connectionTimeout,
  receiveTimeout,
  sendTimeout,
  badCertificate,
  connectionError,
  cancel,
  cacheError,
  noInternetConnection,
  unKnown,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.connectionTimeout:
        return Failure(0, ResponseMessage.connectionTimeout);
      case DataSource.cancel:
        return Failure(0, ResponseMessage.cancel);
      case DataSource.receiveTimeout:
        return Failure(0, ResponseMessage.receiveTimeout);
      case DataSource.sendTimeout:
        return Failure(0, ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return Failure(0, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(0, ResponseMessage.noInternetConnection);
      case DataSource.unKnown:
        return Failure(0, ResponseMessage.unKnown);
      case DataSource.badCertificate:
        return Failure(0, ResponseMessage.badCertificate);
      case DataSource.connectionError:
        return Failure(0, ResponseMessage.badCertificate);
    }
  }
}

class ResponseMessage {
  static const String connectionTimeout = AppString.timeoutError;
  static const String cancel = AppString.requestCanceled;
  static const String receiveTimeout = AppString.timeoutError;
  static const String sendTimeout = AppString.timeoutError;
  static const String cacheError = AppString.cacheError;
  static const String noInternetConnection = AppString.noInternetError;
  static const String unKnown = AppString.unKnownError;
  static const String badCertificate = AppString.badCertificate;
  static const String connectionError = AppString.connectionError;
}
