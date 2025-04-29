part of 'authentication.dart';

class SignInResponseDto {
  final String accessToken;
  final String refreshToken;
  final UserDto user;

  const SignInResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
}
