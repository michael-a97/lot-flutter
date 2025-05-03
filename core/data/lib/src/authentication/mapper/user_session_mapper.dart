import 'package:dtos/dtos.dart' as dtos;
import 'package:session_storage/session_storage.dart' as session_storage;

extension UserSessionMapper on dtos.UserSessionDto {
  session_storage.UserSession toSessionStorage() {
    return session_storage.UserSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user.toSessionStorageModel(),
    );
  }
}

extension UserMapper on dtos.UserDto {
  session_storage.User toSessionStorageModel() {
    return session_storage.User(
      phoneNumber: phoneNumber,
      lastName: lastName,
      firstName: firstName,
      id: id,
      role: switch (role) {
        dtos.Role.user => session_storage.Role.user,
        dtos.Role.attendant => session_storage.Role.attendant,
      },
    );
  }
}
