part of 'user_api_data_source.dart';

class UserApiDataSourceImpl implements UserApiDataSource {
  final Dio _client;

  const UserApiDataSourceImpl(this._client);

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
