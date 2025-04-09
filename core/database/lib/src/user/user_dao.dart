import 'package:drift/drift.dart';

import 'package:dtos/dtos.dart';

import '../../database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.attachedDatabase);

  Future<UserDto?> find() async {
    return select(userTable).map((row) => row.toDto()).getSingle();
  }

  Future<void> save(UserDto user) async {
    await delete(userTable).go();
    await into(userTable).insert(user.toTableData());
  }
}
