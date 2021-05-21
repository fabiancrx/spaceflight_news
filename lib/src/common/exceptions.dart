import 'package:dio/dio.dart';

class ServerException implements Exception {
  final int? statusCode;
  final String message;
  final Object? response;
  final StackTrace? stackTrace;

  ServerException(
      {required this.message, this.statusCode, this.response, this.stackTrace});

  static ServerException fromDioError(DioError error,
      {String? message}) {
    return ServerException(
      statusCode: error.response?.statusCode,
      message: message ?? error.message,
      response: error.response,
      stackTrace: error.stackTrace,
    );
  }

  @override
  String toString() {
    return 'ServerException{statusCode: $statusCode, message: $message}';
  }
}
