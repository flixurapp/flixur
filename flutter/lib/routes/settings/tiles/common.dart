import "package:flixur/routes/settings/index.dart";
import "package:flixur/settings.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsTileShell(
  final SettingsDefinition def, {

  /// Content to either show in place of [trailing] on landscape layouts
  /// or between [content] and subtitle on mobile.
  final Widget? vertical,

  /// Content to show under the title and description.
  final Widget? content,

  /// Content to show at the end of the box.
  final Widget? trailing,
  final VoidCallback? onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final desc = Text(def.description.isNotEmpty ? def.description : def.id);

    return ListTile(
      title: Text(def.name),
      isThreeLine: true,
      subtitle: Column(
        spacing: SettingsView.paddingFor(context, "") * 0.75,
        crossAxisAlignment: .start,
        children: [desc, if (!context.isLandscape) ?vertical, ?content],
      ),
      trailing: context.isLandscape ? (vertical ?? trailing) : trailing,
      onTap: onTap,
      contentPadding: .only(
        left: SettingsView.paddingFor(context, def.id),
        right: SettingsView.paddingFor(context, ""),
      ),
    );
  }
}
