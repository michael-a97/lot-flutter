import 'package:api/api.dart' as api;
import 'package:dtos/dtos.dart' as dtos;

extension SignInResponseMapper on api.SignInResponse {
  dtos.SignInResponseDto toDto() {
    return dtos.SignInResponseDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user.toDto(),
    );
  }
}

extension ApiUserMapper on api.User {
  dtos.UserDto toDto() {
    return dtos.UserDto(
      id: id,
      firstName: firstName,
      lastName: lastName,
      role: switch (role) {
        api.Role.user => dtos.Role.user,
        api.Role.attendant => dtos.Role.attendant,
      },
      phoneNumber: phoneNumber,
    );
  }
}
