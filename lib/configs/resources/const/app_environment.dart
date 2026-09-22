import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

class Environment {
  static final String dev =  dotenv.env['baseUrlDev'] ?? '';
  static final String prod = dotenv.env['baseUrlStg'] ?? '';
  static final String stg = dotenv.env['baseUrlRelease'] ?? '';
  static final String appVersion = dotenv.env['appVersion'] ?? '';
}
