import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../api.dart';

part 'sign_up_request.g.dart';

enum Role { user, attendant }

@JsonSerializable()
class SignUpRequest extends Equatable {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final Role role;
  final String password;
  @JsonKey(includeToJson: false)
  final String phoneNumberVerificationToken;

  const SignUpRequest({
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.password,
    required this.phoneNumberVerificationToken,
  });

  factory SignUpRequest.fromJson(Json json) => _$SignUpRequestFromJson(json);

  Json toJson() => _$SignUpRequestToJson(this);

  @override
  List<Object> get props => [
    phoneNumber,
    firstName,
    lastName,
    role,
    password,
    phoneNumberVerificationToken,
  ];
}
