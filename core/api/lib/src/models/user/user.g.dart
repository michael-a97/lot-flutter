// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  phoneNumber: json['phone_number'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'phone_number': instance.phoneNumber,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'role': _$RoleEnumMap[instance.role]!,
};

const _$RoleEnumMap = {Role.user: 'user', Role.attendant: 'attendant'};
