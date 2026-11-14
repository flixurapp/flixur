import "dart:math";

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

  /// Whether a search is currently active.
  final bool isSearching = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final desc = Text(def.description.isNotEmpty ? def.description : def.id);
    final padLeft = isSearching
        ? SettingsView.paddingFor(context)
        : SettingsView.paddingFor(context, def.id);
    final padRight = SettingsView.paddingFor(context);
    final trailingWidget = context.isLandscape
        ? (vertical ?? trailing)
        : trailing;

    return LayoutBuilder(
      builder: (context, constraints) {
        // cap the trailing widget so it can never throw an error
        final double trailingMax = max(
          0,
          constraints.maxWidth - padLeft - padRight - 40,
        );

        return ListTile(
          title: Text(
            isSearching ? settingTitleSegments(def.id).join(" > ") : def.name,
          ),
          isThreeLine: true,
          subtitle: Column(
            spacing: SettingsView.paddingFor(context) * 0.75,
            crossAxisAlignment: .start,
            children: [desc, if (!context.isLandscape) ?vertical, ?content],
          ),
          trailing: trailingWidget == null
              ? null
              : ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: trailingMax),
                  child: trailingWidget,
                ),
          onTap: onTap,
          contentPadding: .only(left: padLeft, right: padRight),
        );
      },
    );
  }
}
