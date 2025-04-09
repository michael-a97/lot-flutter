import 'package:database/database.dart';
import 'package:dtos/dtos.dart';
import 'package:test/test.dart';

void main() {
  group('$UserDao', () {
    late AppDatabase database;
    late UserDao userDao;

    setUp(() {
      database = AppDatabase.memory();
      userDao = UserDao(database);
    });

    tearDown(() => database.close());

    Future<void> saveTestUser1() async {
      await userDao.save(_testUser1);
    }

    group('save | find', () {
      test('should save the User', () async {
        await userDao.save(_testUser1);

        final result = await userDao.find();

        expect(result, equals(_testUser1));
      });

      test('should replace previously saved user', () async {
        await saveTestUser1();

        await userDao.save(_testUser2);

        final result = await userDao.find();
        expect(result, equals(_testUser2));
      });
    });
  });
}

const _testUser1 = UserDto(
  id: 4,
  phoneNumber: '+251923001100',
  firstName: 'John',
  lastName: 'Doe',
  role: Role.user,
);

const _testUser2 = UserDto(
  id: 99,
  phoneNumber: '+251924112233',
  firstName: 'Jane',
  lastName: 'Doe',
  role: Role.attendant,
);
