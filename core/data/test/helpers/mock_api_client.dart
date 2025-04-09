import 'package:api/api.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {
  final _mockUserApiDataSource = MockUserApiDataSource();
  @override
  UserApiDataSource get user => _mockUserApiDataSource;
}

class MockUserApiDataSource extends Mock implements UserApiDataSource {}
