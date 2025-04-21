import 'dart:async';
import 'dart:convert';

import 'package:secure_storage/secure_storage.dart';

import 'model/user_session.dart';
part 'session_storage_impl.dart';

/// This is an abstract class that defines the contract for session storage.
abstract interface class SessionStorage {
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
