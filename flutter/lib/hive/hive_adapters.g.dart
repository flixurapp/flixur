// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class SettingsPendingPushItemAdapter
    extends TypeAdapter<SettingsPendingPushItem> {
  @override
  final typeId = 13;

  @override
  SettingsPendingPushItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsPendingPushItem(
      profileID: fields[0] as String,
      settingID: fields[1] as String,
      value: fields[2] as String,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsPendingPushItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.profileID)
      ..writeByte(1)
      ..write(obj.settingID)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsPendingPushItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
