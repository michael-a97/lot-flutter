class AppConfig {
  final String version;
  static AppConfig? _instance;

  static AppConfig get instance => _instance!;

  factory AppConfig({required String version}) {
    return _instance ??= AppConfig._(version: version);
  }

  const AppConfig._({required this.version});
}
