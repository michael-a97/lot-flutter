import 'package:database/database.dart';
import 'package:mocktail/mocktail.dart';

class MockAppDatabase extends Mock implements AppDatabase {
  final _mockUserDao = MockUserDao();
  @override
  UserDao get userDao => _mockUserDao;
}

class MockUserDao extends Mock implements UserDao {}
