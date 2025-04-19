// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) =>
    SignUpRequest(
      phoneNumber: json['phone_number'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      password: json['password'] as String,
      phoneNumberVerificationToken:
          json['phone_number_verification_token'] as String,
    );

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role': _$RoleEnumMap[instance.role]!,
      'password': instance.password,
    };

const _$RoleEnumMap = {Role.user: 'user', Role.attendant: 'attendant'};
