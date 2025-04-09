import 'package:json_annotation/json_annotation.dart';

import '../../../api.dart';
export 'sign_up_request.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final Role role;

  const User({
    required this.id,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromJson(Json json) => _$UserFromJson(json);
}
