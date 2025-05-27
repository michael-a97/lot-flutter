import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../api.dart';
import '../../extension/dio_extension.dart';

part 'authentication_api_data_source_impl.dart';

abstract interface class AuthenticationApiDataSource {
  /// Authenticates the user with the given credentials in the [SignInRequest].
  Future<NetworkResponse<SignInResponse>> signIn(SignInRequest request);

  Future<NetworkResponse<Unit>> resetPassword(PasswordResetRequest request);
}
