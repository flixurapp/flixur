import "package:built_value/serializer.dart";
import "package:flixur/hive/hive_registrar.g.dart";
import "package:flixur/settings.dart";
import "package:hive_ce_flutter/hive_ce_flutter.dart";
import "package:openapi/openapi.dart";

@GenerateAdapters(
  [AdapterSpec<SettingsPendingPushItem>()],
  // just reserve a bunch of type IDs
  // this needs changed if we ever serialize more than 10 custom adapters
  reservedTypeIds: {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
)
part "hive_adapters.g.dart";

/// Stores an OpenAPI object through its built_value serializer.
// ignore: prefer_const_constructors_in_immutables
class OpenAPIAdapter<T extends Object>(
  int typeId,
  final Serializer<T> _serializer,
) extends TypeAdapter<T> {
  @override
  final typeId = typeId;

  @override
  T read(BinaryReader reader) {
    final data = standardSerializers.deserializeWith(
      _serializer,
      reader.read(),
    );
    return data!;
  }

  @override
  void write(BinaryWriter writer, T obj) {
    writer.write(standardSerializers.serializeWith(_serializer, obj));
  }
}

// Registers all custom/generated hive adapters.
void registerHiveAdapters() {
  Hive
    ..registerAdapter(OpenAPIAdapter(1, SettingsDefinition.serializer))
    ..registerAdapter(OpenAPIAdapter(2, SettingsGroup.serializer))
    ..registerAdapter(OpenAPIAdapter(3, SettingProfileBody.serializer))
    ..registerAdapter(OpenAPIAdapter(4, SettingValueEntry.serializer))
    ..registerAdapters();
}
