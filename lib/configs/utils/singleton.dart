class Singleton {
  static String token = "";

  static Map<String, dynamic> get header => {
    "Authorization": "Bearer $token",
    'Accept': 'application/json',
  };

  static Map<String, String> headerNoAuth = {'Accept': 'application/json'};

  /// Current user. Type this as your `UserEntity` once the auth feature exists.
  static dynamic user;

  static String? email;
  static int? id;
  static String? appLanguage = 'en';

  static Map<dynamic, dynamic> appSettings = {};

  static void clear() {
    token = "";
    user = null;
    email = null;
    id = null;
  }
}
