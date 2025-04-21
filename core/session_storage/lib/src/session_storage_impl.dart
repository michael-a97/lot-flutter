part of 'session_storage.dart';

class SessionStorageImpl implements SessionStorage {
  final SecureStorage _secureStorage;
  static const int _storageVersion = 1;
  static const String key = 'user_session_v$_storageVersion';
  final StreamController<UserSession?> _userSessionStreamController =
      StreamController();

  SessionStorageImpl(this._secureStorage);

  @override
  Future<void> deleteSession() async {
    await _secureStorage.delete(key: key);

    _userSessionStreamController.add(null);
  }

  @override
  Future<UserSession?> getSession() async {
    final jsonString = await _secureStorage.read(key: key);
    if (jsonString != null) {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return UserSession.fromJson(json);
    }
    return null;
  }

  @override
  Future<void> saveSession(UserSession userSession) async {
    final jsonString = jsonEncode(userSession.toJson());
    await _secureStorage.write(key: key, value: jsonString);
    _userSessionStreamController.add(userSession);
  }

  @override
  Stream<UserSession?> watchSession() => _userSessionStreamController.stream;

  @override
  void close() => _userSessionStreamController.close();
}
