import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:secure_storage/secure_storage.dart';

import 'model/user_session.dart';

part 'session_storage_impl.dart';

/// This is an abstract class that defines the contract for session storage.
abstract interface class SessionStorage {
  factory SessionStorage(Storage secureStorage) = SessionStorageImpl;

  /// Saves the user session to secure storage.
  Future<void> saveSession(UserSession userSession);

  /// Deletes the user session from secure storage.
  Future<void> deleteSession();

  /// Retrieves the user session from secure storage.
  Future<UserSession?> getSession();

  /// Watches for changes in the user session.
  Stream<UserSession?> watchSession();

  /// Closes the stream controller used for watching the session.
  void close();
}
