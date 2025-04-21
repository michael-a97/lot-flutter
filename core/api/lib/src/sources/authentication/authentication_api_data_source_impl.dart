part of 'authentication_api_data_source.dart';

class AuthenticationApiDataSourceImpl implements AuthenticationApiDataSource {
  final Dio _httpClient;

  const AuthenticationApiDataSourceImpl(this._httpClient);

  @override
  Future<NetworkResponse<SignInResponse>> signIn(SignInRequest request) {
    // TODO: implement signIn
    throw UnimplementedError();
  }
}
