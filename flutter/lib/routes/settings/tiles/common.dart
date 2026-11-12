import "package:flixur/routes/settings/index.dart";
import "package:flixur/settings.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsTileShell(
  final SettingsDefinition def, {
  final Widget? content,
  final Widget? trailing,
  final VoidCallback? onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(def.name),
    subtitle:
        content ?? (def.description.isEmpty ? null : Text(def.description)),
    trailing: trailing,
    onTap: onTap,
    contentPadding: .only(
      left: def.id.split(".").length * SettingsView.tilePadding,
      right: SettingsView.tilePadding,
    ),
  );
}
