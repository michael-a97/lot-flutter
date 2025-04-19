import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:dtos/dtos.dart';
import 'package:path/path.dart' as p;

import '../../database.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [UserTable], daos: [UserDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  factory AppDatabase.file({
    String dbNameExtension = '',
    bool enableLogging = false,
    required String path,
  }) {
    return AppDatabase._(
      LazyDatabase(() async {
        final dbFileName = 'lot$dbNameExtension.sqlite';
        final file = File(p.join(path, dbFileName));
        return NativeDatabase(file, logStatements: enableLogging);
      }),
    );
  }

  factory AppDatabase.memory({bool enableLogging = false}) {
    return AppDatabase._(NativeDatabase.memory(logStatements: enableLogging));
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(beforeOpen: _beforeOpen, onUpgrade: _onUpgrade);
  }

  Future<void> _beforeOpen(OpeningDetails details) {
    return customStatement('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Migrator migrator, int from, int to) async {
    for (final table in allTables) {
      await migrator.deleteTable(table.actualTableName);
      await migrator.createTable(table);
    }
  }

  @override
  int get schemaVersion => 1;
}
