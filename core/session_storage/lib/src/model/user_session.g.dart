// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSession _$UserSessionFromJson(Map<String, dynamic> json) => UserSession(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserSessionToJson(UserSession instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
  phoneNumber: json['phoneNumber'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': _$RoleEnumMap[instance.role]!,
  'phoneNumber': instance.phoneNumber,
};

const _$RoleEnumMap = {Role.user: 'user', Role.attendant: 'attendant'};
