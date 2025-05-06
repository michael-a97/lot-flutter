// coverage:ignore-file
part of 'interceptor.dart';

/// An exception that should be thrown when overriding `refreshToken` if the
/// refresh fails and should result in a force-logout.
class RevokeTokenException implements Exception {}

/// A [Dio] interceptor that refreshes the access token when it expires.
///
/// It uses the [session_storage.SessionStorage] to get the current session
/// refresh token  and refreshes the access token when it expires.
class TokenRefreshInterceptor extends Interceptor {
  final Dio _httpClient;
  final String refreshUrl;
  final session_storage.SessionStorage sessionStorage;

  TokenRefreshInterceptor(this.sessionStorage, this.refreshUrl, [Dio? client])
    : _httpClient = client ?? Dio();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type == DioExceptionType.badResponse && err.response != null) {
      final response = err.response!;
      final session = await sessionStorage.getSession();
      if (session == null || !_shouldRefresh(response)) {
        return handler.next(err);
      } else if (_isInvalidRefreshTokenError(response)) {
        await sessionStorage.deleteSession();
        return handler.next(err);
      } else {
        try {
          final refreshResponse = await _tryRefresh(response, session);
          return handler.resolve(refreshResponse);
        } on DioException catch (error) {
          final response = error.response;
          if (response != null && _isInvalidRefreshTokenError(response)) {
            await sessionStorage.deleteSession();
            return handler.next(error);
          } else {
            return handler.reject(err);
          }
        }
      }
    }
    return handler.reject(err);
  }

  bool _isInvalidRefreshTokenError(Response response) {
    if (response.statusCode == 400) {
      final data = response.data;
      return data is Map && data['error'] == 'invalid refresh token';
    }
    return false;
  }

  Future<Response> _proceedRequest(Response response) {
    _httpClient.options.baseUrl = response.requestOptions.baseUrl;
    return _httpClient.request(
      response.requestOptions.path,
      data: response.requestOptions.data,
      options: response.requestOptions.toOptions(),
      cancelToken: response.requestOptions.cancelToken,
      onSendProgress: response.requestOptions.onSendProgress,
      queryParameters: response.requestOptions.queryParameters,
      onReceiveProgress: response.requestOptions.onReceiveProgress,
    );
  }

  Future<session_storage.UserSession> _refreshSession(
    session_storage.UserSession token,
  ) async {
    try {
      final refreshForm = token.toJson();
      final response = await _httpClient.post(refreshUrl, data: refreshForm);
      if (response.statusCode == 200) {
        final data = (response.data as Json)['data'];
        final session = SignInResponse.fromJson(data);

        final refreshedSession = session_storage.UserSession(
          accessToken: session.accessToken,
          refreshToken: session.refreshToken,
          user: session_storage.User(
            phoneNumber: session.user.phoneNumber,
            lastName: session.user.lastName,
            firstName: session.user.firstName,
            id: session.user.id,
            role: switch (session.user.role) {
              Role.user => session_storage.Role.user,
              Role.attendant => session_storage.Role.attendant,
            },
          ),
        );

        await sessionStorage.saveSession(refreshedSession);

        return refreshedSession;
      } else {
        throw RevokeTokenException();
      }
    } on DioException {
      rethrow;
    }
  }

  bool _shouldRefresh(Response response) => response.statusCode == 401;

  Future<Response> _tryRefresh(
    Response response,
    session_storage.UserSession token,
  ) async {
    try {
      await _refreshSession(token);
      return _proceedRequest(response);
    } on RevokeTokenException catch (error) {
      await sessionStorage.deleteSession();
      throw DioException(
        error: error,
        response: response,
        requestOptions: response.requestOptions,
      );
    } on DioException {
      rethrow;
    }
  }
}

extension on RequestOptions {
  Options toOptions() {
    return Options(
      extra: extra,
      method: method,
      headers: headers,
      listFormat: listFormat,
      sendTimeout: sendTimeout,
      contentType: contentType,
      responseType: responseType,
      maxRedirects: maxRedirects,
      receiveTimeout: receiveTimeout,
      validateStatus: validateStatus,
      requestEncoder: requestEncoder,
      responseDecoder: responseDecoder,
      followRedirects: followRedirects,
      receiveDataWhenStatusError: receiveDataWhenStatusError,
    );
  }
}
