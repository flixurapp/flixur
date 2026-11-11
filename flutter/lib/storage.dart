import "dart:convert";
import "dart:typed_data";

import "package:flixur/utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";

const _coreBox = "core";
const _secureBox = "core_secure";

/// Items that can be kept in the persistent storage.
enum Stored { serverUrl, sessionToken, playerID }

/// Persistent storage wrapper for strings.
class Storage {
  static const List<Stored> _secureKeys = [.sessionToken];
  static Box<String> boxFor(Stored key) =>
      _secureKeys.contains(key) ? secure : core;

  static Box<String> get core => Hive.box(_coreBox);
  static Box<String> get secure => Hive.box(_secureBox);

  /// Get a [Stored] item from one of the boxes.
  static String? get(Stored key) {
    return boxFor(key).get(key.name);
  }

  /// Put a [Stored] item into one of the boxes.
  static Future<void> put(Stored key, String value) {
    return boxFor(key).put(key.name, value);
  }

  /// Delete a [Stored] item.
  static Future<void> delete(Stored key) {
    return boxFor(key).delete(key.name);
  }

  /// Watch for changes on a [Stored] item.
  static Stream<BoxEvent> watch(Stored key) {
    return boxFor(key).watch(key: key.name);
  }

  static Future<void> init() async {
    await Hive.initFlutter(AppInfo.dataDirectory);

    final encryptionKey = await _hiveEncryptionKey();

    // open both boxes
    await Hive.openBox<String>(_coreBox);
    await Hive.openBox<String>(
      _secureBox,
      encryptionCipher: encryptionKey == null
          ? null
          : HiveAesCipher(encryptionKey),
    );
  }
}

/// Loads or creates a box encryption key. Returns null if unsupported.
Future<Uint8List?> _hiveEncryptionKey() async {
  const key = "flixur-hive-key";
  const secureStorage = FlutterSecureStorage();

  try {
    final stored = await secureStorage.read(key: key);
    if (stored != null) return base64Decode(stored);

    // generate a new key
    final generated = Hive.generateSecureKey();
    await secureStorage.write(key: key, value: base64Encode(generated));
    return Uint8List.fromList(generated);
    // secure storage will fail on insecure contexts
    // ignore: avoid_catching_errors
  } on UnsupportedError {
    return null;
  }
}
