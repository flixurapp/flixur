import "dart:async";

import "package:flixur/routes/settings/tiles/common.dart";
import "package:flixur/settings.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// A boolean setting.
class const SettingsTileBool(
  final SettingsDefinition def, {
  final bool isSearching = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SettingsTileShell(
    def,
    isSearching: isSearching,
    trailing: Switch(
      value: def.value<bool>(),
      onChanged: (value) => unawaited(Settings.set<bool>(def.id, value)),
    ),
  );
}
