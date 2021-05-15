import 'package:dio/dio.dart';

class ServerException<T> implements Exception {
  final int? statusCode;
  final String message;
  final T? response;
  final StackTrace? stackTrace;

  ServerException(
      {required this.message, this.statusCode, this.response, this.stackTrace});

  static ServerException<Response<dynamic>?> fromDioError(DioError error,
      {String? message}) {
    return ServerException(
      statusCode: error.response?.statusCode,
      message: message ?? error.message,
      response: error.response,
      stackTrace: error.stackTrace,
    );
  }
}
