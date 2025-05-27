import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../api.dart';
import '../../extension/dio_extension.dart';

part 'account_api_data_source_impl.dart';

/// And api data source for managing user account related actions.
abstract interface class AccountApiDataSource {
  /// Registers a user with details provided in the [request].
  Future<NetworkResponse<User>> signUp(SignUpRequest request);
}
