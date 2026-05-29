// ✅ Base Exception class
import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

// ✅ Server Exception - generic
class ServerException<T> extends AppException {
  final T? errorModel; // ✅ للـ typed error models

  const ServerException(super.message, [this.errorModel]);

  @override
  String toString() => message;
}

// ✅ Network Exception
class NetworkException extends AppException {
  const NetworkException(super.message);
}

// ✅ Cache Exception
class CacheException extends AppException {
  const CacheException(super.message);
}

// ✅ Validation Exception
class ValidationException extends AppException {
  const ValidationException(super.message);
}

class UnAuthenticatedException extends AppException {
  const UnAuthenticatedException(super.message);
}

// Map DioException to AppException helper
AppException mapDioErrorToAppException(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.connectionTimeout:
      return const NetworkException('Connection timeout with ApiServer');
    case DioExceptionType.sendTimeout:
      return const NetworkException('Send timeout with ApiServer');
    case DioExceptionType.receiveTimeout:
      return const NetworkException('Receive timeout with ApiServer');
    case DioExceptionType.badResponse:
      final status = dioError.response?.statusCode;
      final data = dioError.response?.data;
      if (status == 401)
        return const UnAuthenticatedException('Invalid token.');
      // try extract message
      String message = dioError.message ?? 'Server error';
      try {
        if (data is Map && data['message'] != null)
          message = data['message'].toString();
      } catch (_) {}
      return ServerException(message, data);
    case DioExceptionType.cancel:
      return const NetworkException('Request to ApiServer was canceled');
    case DioExceptionType.unknown:
      if (dioError.message != null &&
          dioError.message!.contains('SocketException')) {
        return const NetworkException('No Internet Connection');
      }
      return const ServerException(
          'opos there is a proplem please try again ' ?? 'Unexpected Error');
    default:
      return const ServerException(
          'opos there is a proplem please try again ' ?? 'Unexpected Error');
  }
}
