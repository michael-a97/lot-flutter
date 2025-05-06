// coverage:ignore-file
part of 'interceptor.dart';

/// A [Dio] interceptor that adds the authorization header to the request.
///
/// It uses the [session_storage.SessionStorage] to get the current session
/// token and adds the
/// access token to each request. If the token is empty, it will not add the
/// header.
class AuthInterceptor extends Interceptor {
  /// The [session_storage.SessionStorage] used to get the current
  /// session token.
  final session_storage.SessionStorage _session;

  AuthInterceptor(this._session);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = await _session.getSession();
    if (session != null) {
      options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    }
    super.onRequest(options, handler);
  }
}
