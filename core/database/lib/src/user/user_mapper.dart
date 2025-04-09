import 'package:dtos/dtos.dart';

import '../../database.dart';

extension UserTableDataMapper on UserTableData {
  UserDto toDto() {
    return UserDto(
      id: id,
      firstName: firstName,
      lastName: lastName,
      role: role,
      phoneNumber: phoneNumber,
    );
  }
}

extension UserDtoMapper on UserDto {
  UserTableData toTableData() {
    return UserTableData(
      id: id,
      firstName: firstName,
      lastName: lastName,
      role: role,
      phoneNumber: phoneNumber,
    );
  }
}
