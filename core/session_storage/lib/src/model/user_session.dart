import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_session.g.dart';

@JsonSerializable()
class UserSession extends Equatable {
  final String accessToken;
  final String refreshToken;
  final User user;

  const UserSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) =>
      _$UserSessionFromJson(json);

  Map<String, dynamic> toJson() => _$UserSessionToJson(this);

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}

@JsonSerializable()
class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final Role role;
  final String phoneNumber;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [id, firstName, lastName, role, phoneNumber];
}

enum Role { customer, attendant }
