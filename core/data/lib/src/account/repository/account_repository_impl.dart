part of 'account_repository.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final ApiClient _apiClient;
  final AppDatabase _appDatabase;
  final FirebaseAuth _firebaseAuth;

  const AccountRepositoryImpl(
    this._apiClient,
    this._appDatabase,
    this._firebaseAuth,
  );

  @override
  Future<NetworkResponse<UserDto>> signUp(SignUpRequestDto request) async {
    final user = _firebaseAuth.currentUser;
    final token = await user!.getIdToken();
    final response = await _apiClient.user.signUp(
      request.toApi(role: Role.user, phoneNumberVerificationToken: token!),
    );
    if (response.isRight()) {
      final user = response.toOption().toNullable()!.toDto();
      unawaited(_appDatabase.userDao.save(user));
    }
    return response.map((it) => it.toDto());
  }
}
