part of 'authentication.dart';

@JsonSerializable()
class SignInResponse {
  @JsonKey(name: 'id')
  final int userId;
  final String accessToken;
  final String refreshToken;
  final User user;

  const SignInResponse({
    required this.userId,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory SignInResponse.fromJson(Json json) => _$SignInResponseFromJson(json);
}
