part of 'session_storage.dart';

@Singleton(as: SessionStorage)
class SessionStorageImpl implements SessionStorage {
  final Storage _secureStorage;
  static const int _storageVersion = 1;
  static const String key = 'user_session_v$_storageVersion';
  final BehaviorSubject<UserSession?> _userSessionBehaviorSubject =
      BehaviorSubject();

  SessionStorageImpl(this._secureStorage);

  @override
  Future<void> deleteSession() async {
    await _secureStorage.delete(key: key);
    _userSessionBehaviorSubject.add(null);
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
    _userSessionBehaviorSubject.add(userSession);
  }

  @override
  Stream<UserSession?> watchSession() {
    return _userSessionBehaviorSubject.asBroadcastStream().distinct();
  }

  @override
  void close() => _userSessionBehaviorSubject.close();
}
