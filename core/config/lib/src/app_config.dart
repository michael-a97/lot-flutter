part 'supported_countries.dart';

class AppConfig {
  final String version;
  final String baseHttpUrl;
  static AppConfig? _instance;

  static const List<String> supportedCountries = _supportedCountries;

  static AppConfig get instance => _instance!;

  factory AppConfig({required String version, required String baseHttpUrl}) {
    return _instance ??= AppConfig._(
      version: version,
      baseHttpUrl: baseHttpUrl,
    );
  }

  const AppConfig._({required this.version, required this.baseHttpUrl});
}
