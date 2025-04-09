import 'package:dio/dio.dart';
import 'package:networkx/networkx.dart';

import '../../api.dart';

/// Helper methods for [DioException] error.
extension DioExceptionExtension on DioException {
  /// Will return true when a request is cancelled.
  bool get isCancelledError => type == DioExceptionType.cancel;

  /// Will return true when there is no internet connection.
  bool get isConnectionError => type == DioExceptionType.connectionError;

  /// Will return true when [FormatException] is thrown when parsing a response.
  bool get isFormatError => error is FormatException;

  /// Will return true when response is returned with status code between
  /// >= 400 and < 500.
  bool get isResponseError => type == DioExceptionType.badResponse;

  /// Will return true when a request is timeout while connecting, sending, or
  /// receiving a content.
  bool get isTimeoutError {
    return type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout;
  }

  /// Returns [NetworkError] if the error [type] is not
  /// [DioExceptionType.badResponse]. Otherwise, if the [onResponseError]
  /// callback is not null, it will return the result of callback. However, it
  /// the callback is null, it will return [NetworkError.unhandled] error.
  NetworkError<T> toNetWorkError<T>({
    NetworkError<T>? Function(Response response)? onResponseError,
  }) {
    switch (type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
        return NetworkError<T>.timeout();
      case DioExceptionType.badResponse:
        if (response != null) {
          final statusCode = response!.statusCode;
          if (statusCode != null && statusCode >= 500) {
            return NetworkError<T>.server();
          } else if (onResponseError != null) {
            final error = onResponseError(response!);
            if (error != null) return error;
          }
        }
        return NetworkError<T>.unhandled();
      case DioExceptionType.cancel:
        return NetworkError<T>.cancelled();
      case DioExceptionType.connectionError:
      case DioExceptionType.badCertificate:
        return NetworkError<T>.connection();
      case DioExceptionType.unknown:
        if (isFormatError) {
          return NetworkError<T>.format();
        } else {
          return NetworkError<T>.unhandled();
        }
    }
  }

  /// Returns [NetworkError] if the error [type] is not
  /// [DioExceptionType.badResponse]. Otherwise, throws
  /// [UnexpectedNetworkError].
  ///
  /// **Note:** Only use this method if you are sure the request is not going to
  /// result with a response error, which is basically any response with status
  /// code of 400 < 500.
  NetworkError<T> toNetWorkErrorOrThrow<T>() {
    return toNetWorkError(
      onResponseError: (it) => throw UnexpectedNetworkError(it),
    );
  }

  NetworkError<ApiError> toNetworkOrApiError() {
    return toNetWorkError(onResponseError: _parseErrorData);
  }

  NetworkError<ApiError> _parseErrorData(Response response) {
    final statusCode = response.statusCode!;
    final Map data = response.data ?? {};
    final error = data['error'];
    String? message;
    if (error is Map<String, dynamic>) {
      try {
        final firstMessage = error.values.first;
        if (firstMessage is String) message = firstMessage;
      } catch (_) {} // ignore: avoid_catches_without_on_clauses
    } else if (error is String?) {
      message = error;
    }
    message ??= data['message'] as String?;
    final apiError = ApiError(statusCode: statusCode, message: message);
    return NetworkError.api(apiError);
  }
}
