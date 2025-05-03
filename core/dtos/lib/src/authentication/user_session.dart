part of 'authentication.dart';

class UserSessionDto extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserDto user;

  const UserSessionDto({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}
