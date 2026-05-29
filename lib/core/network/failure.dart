import 'package:dio/dio.dart';

class Failure {
  int status;
  String message;

  Failure(this.status, this.message);
}

abstract class Failuree {
  final String errMessage;

  const Failuree(this.errMessage);
}

class ServerFailure extends Failuree {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceled');

      case DioExceptionType.unknown:
        if (dioError.message != null && dioError.message!.contains('SocketException')) {
          return ServerFailure('No Internet Connection');
        }
        return ServerFailure('Unexpected Error, Please try again!');
      default:
        return ServerFailure('Oops There was an Error, Please try again');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    String errorMessage = 'Oops There was an Error, Please try again';

    if (response is Map && response.containsKey('message')) {
      final msg = response['message'];
      if (msg is List && msg.isNotEmpty) {
        errorMessage = msg[0].toString();
      } else if (msg is String && msg.isNotEmpty) {
        errorMessage = msg;
      } else if (msg != null) {
        errorMessage = msg.toString();
      }
    } else if (statusCode != null) {
      if (statusCode == 401) {
        errorMessage = 'Unauthorized, Please login again';
      } else if (statusCode == 404) {
        errorMessage = 'Your request not found, Please try later!';
      } else if (statusCode >= 500) {
        errorMessage = 'Internal Server error, Please try later';
      }
    }

    return ServerFailure(errorMessage);
  }
}
