import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";

class Storage {
  static const _playerIDKey = "flixur-player-id";
  static const _serverUrlKey = "flixur-server-url";
  static const _sessionTokenKey = "flixur-session";

  static final _sharedPrefs = SharedPreferencesAsync();
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    // cache values
    serverUrl.value = await _sharedPrefs.getString(_serverUrlKey);
    sessionToken.value = await _secureStorage.read(key: _sessionTokenKey);
    playerID.value = await _sharedPrefs.getString(_playerIDKey);
  }

  // Base URL for the server API client.
  static ValueNotifier<String?> serverUrl = .new(null);
  static Future<void> setServerUrl(String url) async {
    await _sharedPrefs.setString(_serverUrlKey, url);
    serverUrl.value = url;
  }

  // Session token for logged in users.
  static ValueNotifier<String?> sessionToken = .new(null);
  static Future<void> setSessionToken(String token) async {
    await _secureStorage.write(key: _sessionTokenKey, value: token);
    sessionToken.value = token;
  }

  // Identifier for this player. This is returned from the server.
  static ValueNotifier<String?> playerID = .new("");
  static Future<void> setPlayerID(String id) async {
    await _sharedPrefs.setString(_playerIDKey, id);
    playerID.value = id;
  }
}
