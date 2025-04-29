import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../api.dart';

class ApiClient {
  final UserApiDataSource user;
  final AuthenticationApiDataSource authentication;

  const ApiClient._({required this.user, required this.authentication});

  factory ApiClient.create({
    bool log = false,
    bool debug = false,
    required String baseUrl,
  }) {
    final httpClient = _createHttpClient(
      baseUrl: baseUrl,
      debug: debug,
      log: log,
    );
    return ApiClient._(
      user: UserApiDataSourceImpl(httpClient),
      authentication: AuthenticationApiDataSourceImpl(httpClient),
    );
  }

  static Dio _createHttpClient({
    required String baseUrl,
    required debug,
    required log,
  }) {
    const timeDuration = Duration(seconds: 30);
    final options = BaseOptions(
      connectTimeout: timeDuration,
      receiveTimeout: timeDuration,
      baseUrl: baseUrl,
      followRedirects: true,
    );

    final httpClient = Dio(options);
    final interceptors = [
      if (debug) PrettyDioLogger(requestBody: true, requestHeader: true),
    ];
    httpClient.interceptors.addAll(interceptors);

    return httpClient;
  }
}
