import "package:flutter_secure_storage/flutter_secure_storage.dart";

const _sessopmTokenKey = "flixur-session";

const secureStorage = FlutterSecureStorage();

// Saves an auth token to storage.
Future<void> saveSessionToken(String token) async {
  await secureStorage.write(key: _sessopmTokenKey, value: token);
}
