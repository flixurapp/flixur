import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";

class Storage {
  static const _sessionTokenKey = "flixur-session";
  static const _serverUrlKey = "flixur-server-url";

  static late SharedPreferencesWithCache _sharedPrefs;
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    // init shared preferences/cache
    _sharedPrefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    // cache the session token
    sessionToken = await _secureStorage.read(key: _sessionTokenKey);
  }

  static String? sessionToken;
  static String? get serverUrl => _sharedPrefs.getString(_serverUrlKey);

  // Saves a new session token to storage and caches it.
  static Future<void> setSessionToken(String token) async {
    await _secureStorage.write(key: _sessionTokenKey, value: token);
    sessionToken = token;
  }

  static Future<void> setServerUrl(String url) async {
    await _sharedPrefs.setString(_serverUrlKey, url);
  }
}
