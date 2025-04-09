import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:networkx/networkx.dart';

/// A type alias for maps with string keys and dynamic values.
typedef Json = Map<String, dynamic>;

/// A network error returned from a method that makes an API call.
typedef ApiNetworkError = NetworkError<ApiError>;

/// A typical response returned from a network call.
typedef NetworkResponse<T> = Either<ApiNetworkError, T>;

/// A class for representing a network error returned from the api.
@immutable
class ApiError {
  final int statusCode;
  final String? message;

  const ApiError({required this.statusCode, this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiError &&
          runtimeType == other.runtimeType &&
          statusCode == other.statusCode &&
          message == other.message;

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode;
}
