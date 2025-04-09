import 'package:drift/drift.dart';
import 'package:dtos/dtos.dart';

import '../common/base_table.dart';

class UserTable extends TableWithPrimaryKeyId {
  TextColumn get firstName => text()();

  TextColumn get lastName => text()();

  TextColumn get phoneNumber => text()();

  TextColumn get role => textEnum<Role>()();
}
