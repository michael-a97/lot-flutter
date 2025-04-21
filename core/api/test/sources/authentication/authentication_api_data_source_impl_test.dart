import 'package:api/api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../helpers/dio_helpers.dart';
import 'authentication_api_data_source_fixtures.dart';

void main() {
  group('$AuthenticationApiDataSourceImpl', () {
    late Dio httpClient;
    late AuthenticationApiDataSourceImpl authenticationApiDataSourceImpl;

    setUp(() {
      httpClient = MockDio();
      authenticationApiDataSourceImpl = AuthenticationApiDataSourceImpl(
        httpClient,
      );
    });

    group('signIn', () {
      const path = '/api/v1/auth/signin';
      const request = SignInRequest(
        phoneNumber: '+251923001100',
        password: 'pass1234',
      );
      Future<Response> httpRequest() =>
          httpClient.post(path, data: request.toJson());

      test('should return a SignInResponse when successful', () async {
        when(httpRequest).thenAnswer((_) async {
          return FakeResponse(data: signInSuccessResponse);
        });

        final response = await authenticationApiDataSourceImpl.signIn(request);

        expect(response.toOption().toNullable(), isA<SignInResponse>());
      });

      test('should return a NetworkError when an error occurs', () async {
        when(
          httpRequest,
        ).thenThrow(FakeDioException(DioExceptionType.connectionTimeout));

        final response = await authenticationApiDataSourceImpl.signIn(request);

        expect(response, left(const ApiNetworkError.timeout()));
      });
    });
  });
}
