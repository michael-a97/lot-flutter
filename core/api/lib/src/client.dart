import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:session_storage/session_storage.dart';

import '../api.dart';
import 'interceptor/interceptor.dart';

class ApiClient {
  final AccountApiDataSource user;
  final AuthenticationApiDataSource authentication;
  final SessionStorage sessionStorage;

  const ApiClient._({
    required this.user,
    required this.authentication,
    required this.sessionStorage,
  });

  factory ApiClient.create({
    bool log = false,
    bool debug = false,
    required String baseUrl,
    required SessionStorage sessionStorage,
  }) {
    final httpClient = _createHttpClient(
      sessionStorage: sessionStorage,
      baseUrl: baseUrl,
      debug: debug,
      log: log,
    );
    return ApiClient._(
      user: AccountApiDataSourceImpl(httpClient),
      authentication: AuthenticationApiDataSourceImpl(httpClient),
      sessionStorage: sessionStorage,
    );
  }

  static Dio _createHttpClient({
    required String baseUrl,
    required debug,
    required log,
    required SessionStorage sessionStorage,
  }) {
    const timeDuration = Duration(seconds: 30);
    final options = BaseOptions(
      connectTimeout: timeDuration,
      receiveTimeout: timeDuration,
      baseUrl: baseUrl,
      followRedirects: true,
    );

    final httpClient = Dio(options);
    final authInterceptor = AuthInterceptor(sessionStorage);
    final refreshInterceptor = TokenRefreshInterceptor(
      sessionStorage,
      '$baseUrl/api/v1/auth/refresh',
    );
    final interceptors = [
      if (debug) PrettyDioLogger(requestBody: true, requestHeader: true),
      refreshInterceptor,
      authInterceptor,
    ];
    httpClient.interceptors.addAll(interceptors);

    return httpClient;
  }
}
