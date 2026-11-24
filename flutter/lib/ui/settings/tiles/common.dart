import "dart:math";

import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/settings/menu.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsTileShell(
  final SettingsDefinition def,
  final SettingsValues values, {

  /// Content to either show in place of [trailing] on landscape layouts
  /// or after [content] on mobile.
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
        ? SettingsMenu.paddingFor(context)
        : SettingsMenu.paddingFor(context, def.id);
    final padRight = SettingsMenu.paddingFor(context);
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
          title: Row(
            spacing: 2,
            children: [
              if (!def.isDefault(values.getValue(def.id)))
                IconButton(
                  onPressed: () =>
                      values.set(def.id, def.getDefault<dynamic>()),
                  icon: const Iconify("arrow-counter-clockwise"),
                  tooltip: t.routes.settings.reset_setting,
                  constraints: .tight(const .square(36)),
                ),
              Expanded(
                child: Text(
                  isSearching
                      // use non-breaking spaces to force wrapping at divider
                      ? SettingsTranslated.defSegments(def.id)
                            .map((s) => s.replaceAll(" ", "\u00A0"))
                            .join("\u00A0> ")
                      : def.name,
                ),
              ),
            ],
          ),
          isThreeLine: true,
          subtitle: Column(
            spacing: SettingsMenu.paddingFor(context) * 0.75,
            crossAxisAlignment: .start,
            children: [desc, ?content, if (!context.isLandscape) ?vertical],
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
