import 'package:drift/drift.dart';

class TableWithAutoIncrementPrimaryKeyId extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
}

class TableWithPrimaryKeyId extends Table {
  IntColumn get id => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
