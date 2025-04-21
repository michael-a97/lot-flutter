part of 'authentication.dart';

@JsonSerializable()
class SignInRequest {
  final String phoneNumber;
  final String password;

  const SignInRequest({required this.phoneNumber, required this.password});

  Json toJson() => _$SignInRequestToJson(this);
}
