import 'package:dio/dio.dart';

import '../../../api.dart';

part 'authentication_api_data_source_impl.dart';

abstract interface class AuthenticationApiDataSource {
  /// Authenticates the user with the given credentials in the [SignUpRequest].
  Future<NetworkResponse<SignInResponse>> signIn(SignUpRequest request);
}
