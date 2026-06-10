import 'package:dio/dio.dart';

import 'api_result.dart';

class ApiErrorHandler {
  static ApiException handle(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return ApiException(
        message: 'Network error. Please check your connection.',
      );
    }

    final response = error.response;
    if (response == null) {
      return ApiException(message: 'Something went wrong. Please try again.');
    }

    final statusCode = response.statusCode;
    final data = response.data;
    final message = _extractMessage(data);

    switch (statusCode) {
      case 401:
        return ApiException(
          message: message ?? 'Unauthorized. Please login again.',
          statusCode: statusCode,
        );
      case 404:
        return ApiException(
          message: message ?? 'Resource not found.',
          statusCode: statusCode,
        );
      case 422:
        return ApiException(
          message: message ?? 'Validation error.',
          statusCode: statusCode,
          errors: _extractErrors(data),
        );
      case 500:
        return ApiException(
          message: message ?? 'Internal server error.',
          statusCode: statusCode,
        );
      default:
        return ApiException(
          message: message ?? 'Unexpected error occurred.',
          statusCode: statusCode,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;

      final error = data['error'];
      if (error is String && error.isNotEmpty) return error;
    }
    return null;
  }

  static Map<String, dynamic>? _extractErrors(dynamic data) {
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) return errors;
    }
    return null;
  }
}
