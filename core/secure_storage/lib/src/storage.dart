/// A Dart storage client interface.
abstract interface class Storage {
  /// Removes all key, value pairs asynchronously.
  Future<void> clear();

  /// Removes the value for the provided [key] asynchronously.
  Future<void> delete({required String key});

  /// Returns value for the provided [key].
  /// Read returns `null` if no value is found for the given [key].
  Future<String?> read({required String key});

  /// Writes the provided [key], [value] pair asynchronously.
  Future<void> write({required String key, required String value});
}
