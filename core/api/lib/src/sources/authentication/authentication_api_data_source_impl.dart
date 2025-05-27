part of 'authentication_api_data_source.dart';

class AuthenticationApiDataSourceImpl implements AuthenticationApiDataSource {
  final Dio _httpClient;

  const AuthenticationApiDataSourceImpl(this._httpClient);

  @override
  Future<NetworkResponse<SignInResponse>> signIn(SignInRequest request) async {
    try {
      const path = '/api/v1/auth/signin';
      final body = request.toJson();
      final response = await _httpClient.post(path, data: body);
      final data = (response.data as Json)['data'];
      return right(SignInResponse.fromJson(data));
    } on DioException catch (e) {
      return left(e.toNetworkOrApiError());
    }
  }

  @override
  Future<NetworkResponse<Unit>> resetPassword(
    PasswordResetRequest request,
  ) async {
    try {
      const path = '/api/v1/auth/reset-password';
      final body = request.toJson();
      final options = Options(
        headers: {
          'Authorization': 'Bearer ${request.phoneNumberVerificationToken}',
        },
      );
      await _httpClient.post(path, data: body, options: options);
      return right(unit);
    } on DioException catch (e) {
      return left(e.toNetworkOrApiError());
    }
  }
}
