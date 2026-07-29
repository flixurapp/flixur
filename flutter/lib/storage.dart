import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";

class Storage {
  static const _sessionTokenKey = "flixur-session";

  static late SharedPreferencesWithCache sharedPrefs;
  static const secureStorage = FlutterSecureStorage();

  static String? sessionToken;

  static Future<void> init() async {
    // init shared preferences/cache
    sharedPrefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    // cache the session token
    sessionToken = await secureStorage.read(key: _sessionTokenKey);
  }

  // Saves a new session token to storage.
  static Future<void> saveSessionToken(String token) async {
    await secureStorage.write(key: _sessionTokenKey, value: token);
    sessionToken = token;
  }
}
