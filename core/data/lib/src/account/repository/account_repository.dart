import 'dart:async';

import 'package:api/api.dart';
import 'package:database/database.dart';
import 'package:dtos/dtos.dart' hide Role;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../account.dart';

part 'account_repository_impl.dart';

abstract interface class AccountRepository {
  ///Signs up a user with the given [SignUpRequestDto].
  Future<NetworkResponse<UserDto>> signUp(SignUpRequestDto request);
}
