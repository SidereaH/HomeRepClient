import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  factory AppConfig() {
    return _singleton;
  }

  AppConfig._();

  static final AppConfig _singleton = AppConfig._();

  static bool get IS_PRODUCTION =>
      kReleaseMode || ENVIRONMENT.toLowerCase().startsWith('prod');

  static String get ENVIRONMENT => dotenv.env['ENVIRONMENT'] ?? 'dev';

  static String get API_URI => dotenv.env['API_URI']!;
  static String get YANDEX_API_KEY => dotenv.env['YANDEX_API_KEY']!;
  static String get YANDEX_SUGGEST_KEY => dotenv.env['YANDEX_SUGGEST_KEY']!;
  static String get YANDEX_GEOCODER => dotenv.env['YANDEX_GEOCODER']!;
  static String get MAIN_API_URI => dotenv.env['AUTH_API_URI']!;

  Future<void> load() async {
    await dotenv.load(fileName: 'assets/.env');
    debugPrint('ENVIRONMENT: $ENVIRONMENT');
    debugPrint('API ENDPOINT: $API_URI');
    debugPrint('YANDEX: $YANDEX_API_KEY');
    debugPrint('Geo: $YANDEX_SUGGEST_KEY');
    debugPrint('GeoCode: $YANDEX_GEOCODER');
  }
}