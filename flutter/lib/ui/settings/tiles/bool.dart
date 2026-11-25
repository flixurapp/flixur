import "dart:async";

import "package:flixur/ui/settings/tiles/common.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// A boolean setting.
class const SettingsTileBool(
  final SettingsDefinition def,
  final SettingsValues values, {
  final bool isSearching = false,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final override = useState<bool?>(null);

    // update with the setting
    final revision = useSettingsChanges(values, [def.id]);
    useEffect(() {
      override.value = null;
      return null;
    }, [revision]);

    return SettingsTileShell(
      def,
      values,
      isSearching: isSearching,
      trailing: Switch(
        value: override.value ?? values.getValue<bool>(def.id),
        onChanged: (value) {
          override.value = value;
          unawaited(values.set<bool>(def.id, value));
        },
      ),
    );
  }
}
