import "dart:async";

import "package:flixur/ui/settings/tiles/common.dart";
import "package:flixur/ui/settings/values.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// A boolean setting.
class const SettingsTileBool(
  final SettingsDefinition def,
  final SettingsValues values, {
  final bool isSearching = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SettingsTileShell(
    def,
    values,
    isSearching: isSearching,
    trailing: Switch(
      value: values.getValue<bool>(def.id),
      onChanged: (value) => unawaited(values.set<bool>(def.id, value)),
    ),
  );
}
