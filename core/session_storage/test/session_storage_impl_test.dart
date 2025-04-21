import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:session_storage.dart/src/model/user_session.dart';
import 'package:session_storage.dart/src/session_storage.dart';

void main() {
  group('$SessionStorageImpl', () {
    late SessionStorageImpl storageImpl;
    late SecureStorage secureStorage;

    setUp(() {
      secureStorage = MockSecureStorage();
      storageImpl = SessionStorageImpl(secureStorage);
    });

    group('getSession', () {
      test('should return saved user session', () async {
        when(
          () => secureStorage.read(key: 'user_session_v1'),
        ).thenAnswer((_) async => jsonEncode(_userSession.toJson()));

        final session = await storageImpl.getSession();

        expect(session, _userSession);
      });
    });

    group('saveSession', () {
      test('should write session', () async {
        when(
          () => secureStorage.write(
            key: 'user_session_v1',
            value: jsonEncode(_userSession.toJson()),
          ),
        ).thenAnswer((_) async {});

        await storageImpl.saveSession(_userSession);

        verify(
          () => secureStorage.write(
            key: 'user_session_v1',
            value: jsonEncode(_userSession.toJson()),
          ),
        ).called(1);
      });
    });

    group('watchSession', () {
      test('should return a stream of user session', () async {
        final result = storageImpl.watchSession();
        expect(result, isA<Stream<UserSession?>>());
      });

      test(
        'should emit new user session when a new user session is saved',
        () async {
          when(
            () => secureStorage.write(
              key: 'user_session_v1',
              value: jsonEncode(_userSession.toJson()),
            ),
          ).thenAnswer((_) async {});

          final stream = storageImpl.watchSession();
          await storageImpl.saveSession(_userSession);

          await expectLater(stream, emits(_userSession));
        },
      );

      test('should emit null when the user session is deleted', () async {
        when(
          () => secureStorage.delete(key: 'user_session_v1'),
        ).thenAnswer((_) async {});

        await storageImpl.deleteSession();
        final stream = storageImpl.watchSession();

        await expectLater(stream, emits(null));
      });
    });
  });
}

class MockSecureStorage extends Mock implements SecureStorage {}

const _userSession = UserSession(
  accessToken: 'access-token',
  refreshToken: 'refresh_token',
  user: User(
    id: 1,
    firstName: 'John',
    lastName: 'Doe',
    role: Role.customer,
    phoneNumber: '+251923001100',
  ),
);
