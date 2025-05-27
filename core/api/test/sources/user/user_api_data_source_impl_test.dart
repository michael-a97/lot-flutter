import 'package:api/api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../helpers/dio_helpers.dart';
import 'user_api_data_source_fixtures.dart';

void main() {
  group('$AccountApiDataSourceImpl', () {
    late Dio httpClient;
    late AccountApiDataSourceImpl userApiDataSourceImpl;

    setUp(() {
      httpClient = MockDio();
      userApiDataSourceImpl = AccountApiDataSourceImpl(httpClient);
    });

    group('signUp', () {
      const path = '/api/v1/user/signup';
      const request = SignUpRequest(
        phoneNumber: '+251923001100',
        firstName: 'John',
        lastName: 'Doe',
        role: Role.user,
        password: 'pass1234',
        phoneNumberVerificationToken: '123123',
      );

      registerFallbackValue(
        Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${request.phoneNumberVerificationToken}',
          },
        ),
      );
      Future<Response> httpRequest() => httpClient.post(
        path,
        data: request.toJson(),
        options: any(named: 'options'),
      );

      test('should return a User when successful', () async {
        when(
          httpRequest,
        ).thenAnswer((_) async => FakeResponse(data: signUpSuccessResponse));
        final result = await userApiDataSourceImpl.signUp(request);

        expect(result.toOption().toNullable(), isA<User>());
      });

      test('should return an ApiNetworkError when unsuccessful', () async {
        when(
          httpRequest,
        ).thenThrow(FakeDioException(DioExceptionType.connectionTimeout));

        final result = await userApiDataSourceImpl.signUp(request);

        expect(result, left(const ApiNetworkError.timeout()));
      });
    });
  });
}
