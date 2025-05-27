part of 'account_api_data_source.dart';

class AccountApiDataSourceImpl implements AccountApiDataSource {
  final Dio _client;

  const AccountApiDataSourceImpl(this._client);

  @override
  Future<NetworkResponse<User>> signUp(SignUpRequest request) async {
    try {
      const path = '/api/v1/user/signup';
      final data = request.toJson();
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${request.phoneNumberVerificationToken}',
      };
      final response = await _client.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
      final json = response.data as Json;
      final userJson = json['data'] as Json;
      final user = User.fromJson(userJson);
      return right(user);
    } on DioException catch (e) {
      return left(e.toNetworkOrApiError());
    }
  }
}
