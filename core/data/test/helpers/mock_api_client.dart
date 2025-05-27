import 'package:api/api.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {
  final _mockUserApiDataSource = MockUserApiDataSource();
  final _mockAuthenticationApiDataSource = MockAuthenticationApiDataSource();

  @override
  AccountApiDataSource get user => _mockUserApiDataSource;

  @override
  AuthenticationApiDataSource get authentication =>
      _mockAuthenticationApiDataSource;
}

class MockUserApiDataSource extends Mock implements AccountApiDataSource {}

class MockAuthenticationApiDataSource extends Mock
    implements AuthenticationApiDataSource {}
