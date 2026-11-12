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
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(def.name),
      isThreeLine: true,
      subtitle:
          content ??
          Text(def.description.isNotEmpty ? def.description : def.id),
      trailing: trailing,
      onTap: onTap,
      contentPadding: .only(
        left: def.id.split(".").length * SettingsView.tilePadding,
        right: SettingsView.tilePadding,
      ),
    );
  }
}
