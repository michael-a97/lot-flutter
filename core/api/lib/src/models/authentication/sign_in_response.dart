part of 'authentication.dart';

@JsonSerializable(createToJson: false)
class SignInResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  const SignInResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SignInResponse.fromJson(Json json) => _$SignInResponseFromJson(json);
}
