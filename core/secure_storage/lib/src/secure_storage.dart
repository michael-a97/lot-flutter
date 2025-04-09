import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage.dart';
export 'storage.dart';

/// {@template secure_storage}
/// A Secure Storage client which implements the base [Storage] interface.
/// [SecureStorage] uses `FlutterSecureStorage` internally.
///
/// ```dart
/// // Create a `SecureStorage` instance.
/// final storage = const SecureStorage();
///
/// // Write a key-value pair.
/// await storage.write(key: 'my_key', value: 'my_value');
///
/// // Read value for key.
/// final value = await storage.read(key: 'my_key'); // 'my_value'
/// ```
/// {@endtemplate}
class SecureStorage implements Storage {
  final FlutterSecureStorage _secureStorage;

  /// {@macro secure_storage}
  ///
  /// [accountName] is only used on iOS. It is the name of the keychain
  /// account to use. If not provided, the default account name is used.
  ///
  /// [secureStorage] should be used for testing purposes. It is the instance of
  /// `FlutterSecureStorage` to use. If not provided, a new instance is created.
  SecureStorage([String? accountName, FlutterSecureStorage? secureStorage])
    : _secureStorage =
          secureStorage ??
          FlutterSecureStorage(
            iOptions:
                accountName != null
                    ? IOSOptions(accountName: accountName)
                    : IOSOptions.defaultOptions,
            aOptions: const AndroidOptions(
              encryptedSharedPreferences: true,
              resetOnError: true,
            ),
          );

  @override
  Future<void> clear() async {
    await _secureStorage.deleteAll();
  }

  @override
  Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  @override
  Future<String?> read({required String key}) async {
    return _secureStorage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }
}
