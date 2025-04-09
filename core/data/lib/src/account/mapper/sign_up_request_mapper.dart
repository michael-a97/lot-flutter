import 'package:api/api.dart' as api;
import 'package:dtos/dtos.dart' as dtos;

extension SignUpRequestMapper on dtos.SignUpRequestDto {
  api.SignUpRequest toApi({
    required api.Role role,
    required String phoneNumberVerificationToken,
  }) {
    return api.SignUpRequest(
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      password: password,
      phoneNumberVerificationToken: phoneNumberVerificationToken,
      role: role,
    );
  }
}

extension UserMapper on api.User {
  dtos.UserDto toDto() {
    return dtos.UserDto(
      id: id,
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      role: role.toDto(),
    );
  }
}

extension RoleMapper on api.Role {
  dtos.Role toDto() {
    switch (this) {
      case api.Role.user:
        return dtos.Role.user;
      case api.Role.attendant:
        return dtos.Role.attendant;
    }
  }
}
