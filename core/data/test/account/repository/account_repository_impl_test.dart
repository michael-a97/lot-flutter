import 'package:api/api.dart';
import 'package:dartz/dartz.dart';
import 'package:data/src/account/account.dart';
import 'package:database/database.dart';
import 'package:dtos/dtos.dart' hide Role;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../helpers/mock_api_client.dart';
import '../../helpers/mock_app_database.dart';

void main() {
  group('$AccountRepositoryImpl', () {
    late MockApiClient apiClient;
    late AccountRepositoryImpl accountRepositoryImpl;
    late AppDatabase appDatabase;
    late firebase.FirebaseAuth firebaseAuth;

    setUp(() {
      apiClient = MockApiClient();
      appDatabase = MockAppDatabase();
      firebaseAuth = _MockFirebaseAuth();

      accountRepositoryImpl = AccountRepositoryImpl(
        apiClient,
        appDatabase,
        firebaseAuth,
      );
    });

    group('signUp', () {
      const phoneNumberVerificationToken = '123456';
      final firebaseUser = MockFirebaseUser();
      when(firebaseUser.getIdToken).thenAnswer((_) async {
        return phoneNumberVerificationToken;
      });

      test('should return a UserDto when successful', () async {
        const signUpRequestDto = SignUpRequestDto(
          phoneNumber: '1234567890',
          firstName: 'John',
          lastName: 'Doe',
          password: 'password1234',
        );

        final signUpRequest = SignUpRequest(
          phoneNumber: signUpRequestDto.phoneNumber,
          firstName: signUpRequestDto.firstName,
          lastName: signUpRequestDto.lastName,
          role: Role.user,
          password: signUpRequestDto.password,
          phoneNumberVerificationToken: phoneNumberVerificationToken,
        );

        const user = User(
          id: 1,
          phoneNumber: '1234567890',
          firstName: 'John',
          lastName: 'Doe',
          role: Role.user,
        );

        when(
          () => apiClient.user.signUp(signUpRequest),
        ).thenAnswer((_) async => right(user));

        when(
          () => appDatabase.userDao.save(user.toDto()),
        ).thenAnswer((_) async {});

        when(() => firebaseAuth.currentUser).thenAnswer((_) => firebaseUser);

        when(() => appDatabase.userDao.save(user.toDto())).thenAnswer((
          _,
        ) async {
          return Future.value();
        });

        final result = await accountRepositoryImpl.signUp(signUpRequestDto);

        expect(
          result,
          equals(
            right(
              UserDto(
                id: user.id,
                phoneNumber: user.phoneNumber,
                firstName: user.firstName,
                lastName: user.lastName,
                role: user.role.toDto(),
              ),
            ),
          ),
        );
      });

      test('should return a NetworkApiError when unsuccessful', () async {
        const signUpRequestDto = SignUpRequestDto(
          phoneNumber: '1234567890',
          firstName: 'John',
          lastName: 'Doe',
          password: 'password1234',
        );

        final signUpRequest = SignUpRequest(
          phoneNumber: signUpRequestDto.phoneNumber,
          firstName: signUpRequestDto.firstName,
          lastName: signUpRequestDto.lastName,
          role: Role.user,
          password: signUpRequestDto.password,
          phoneNumberVerificationToken: phoneNumberVerificationToken,
        );

        when(
          () => apiClient.user.signUp(signUpRequest),
        ).thenAnswer((_) async => left(const ApiNetworkError.timeout()));

        when(() => firebaseAuth.currentUser).thenAnswer((_) => firebaseUser);

        final result = await accountRepositoryImpl.signUp(signUpRequestDto);

        expect(result, equals(left(const ApiNetworkError.timeout())));
      });
    });
  });
}

class _MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase.User {}
