import 'package:dio/dio.dart';

// ✅ Base Failure class - generic
abstract class Failure<T> {
  final String errMessage;
  final T? errorData; // ✅ إضافة error data للـ typed errors

  const Failure(this.errMessage, [this.errorData]);

  @override
  String toString() => errMessage;
}

// ✅ Server Failure - generic
class ServerFailure<T> extends Failure<T> {
  ServerFailure(super.errMessage, [super.errorData]);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure<T>('Connection timeout with ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure<T>('Send timeout with ApiServer');

      case DioExceptionType.receiveTimeout:
        return ServerFailure<T>('Receive timeout with ApiServer');

      case DioExceptionType.badResponse:
        return ServerFailure<T>.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure<T>('Request to ApiServer was canceled');

      case DioExceptionType.unknown:
        if (dioError.message != null &&
            dioError.message!.contains('SocketException')) {
          return ServerFailure<T>('No Internet Connection');
        }
        return ServerFailure<T>('Unexpected Error, Please try again!');

      default:
        return ServerFailure<T>('Oops There was an Error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    String errorMessage = 'Oops There was an Error, Please try again';

    if (response is Map) {
      final validationMessage = _validationErrorsMessage(response);
      if (validationMessage != null) {
        errorMessage = validationMessage;
      } else if (response.containsKey('message')) {
        final msg = response['message'];
        if (msg is List && msg.isNotEmpty) {
          errorMessage = msg[0].toString();
        } else if (msg is String && msg.isNotEmpty) {
          errorMessage = msg;
        } else if (msg != null) {
          errorMessage = msg.toString();
        }
      } else if (response['title'] is String &&
          (response['title'] as String).isNotEmpty) {
        errorMessage = response['title'] as String;
      }
    } else if (statusCode != null) {
      if (statusCode == 401) {
        errorMessage = 'بيانات الدخول غير صحيحة. تأكد من البريد وكلمة المرور';
      } else if (statusCode == 404) {
        errorMessage = 'Your request not found, Please try later!';
      } else if (statusCode >= 500) {
        errorMessage = 'Internal Server error, Please try later';
      }
    }

    return ServerFailure<T>(errorMessage);
  }

  static String? _validationErrorsMessage(Map response) {
    final errors = response['errors'];
    if (errors is! Map) return null;

    final messages = <String>[];
    for (final entry in errors.entries) {
      final value = entry.value;
      if (value is List) {
        for (final item in value) {
          final text = item?.toString().trim() ?? '';
          if (text.isNotEmpty) messages.add(text);
        }
      } else if (value is String && value.trim().isNotEmpty) {
        messages.add(value.trim());
      }
    }
    return messages.isEmpty ? null : messages.join('\n');
  }
}

// ✔️ Unauthenticated server failure (typed)
class UnauthenticatedServerFailure<T> extends ServerFailure<T> {
  UnauthenticatedServerFailure(
      [super.message = 'Unauthenticated', super.errorData]);
}

// ✅ Network Failure
class NetworkFailure<T> extends Failure<T> {
  NetworkFailure(super.errMessage, [super.errorData]);
}

// ✅ Cache Failure
class CacheFailure<T> extends Failure<T> {
  CacheFailure(super.errMessage, [super.errorData]);
}

// ✅ Validation Failure
class ValidationFailure<T> extends Failure<T> {
  ValidationFailure(super.errMessage, [super.errorData]);
}
