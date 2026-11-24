import "dart:async";

import "package:flixur/hooks.dart";
import "package:flixur/routes/settings/tiles/common.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/theme.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// An enum setting with fixed choices.
class const SettingsTileEnum(
  final SettingsDefinition def, {
  final bool isSearching = false,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: SettingsTranslated.choiceName(def.id, def.value<String>()),
    );

    // keep controller in sync
    final revision = useSettings([def.id]);
    useEffect(() {
      final name = SettingsTranslated.choiceName(def.id, def.value<String>());
      if (controller.text != name) controller.text = name;
      return null;
    }, [revision]);

    return LayoutBuilder(
      builder: (context, constraints) => SettingsTileShell(
        def,
        isSearching: isSearching,
        vertical: FlixurDropdownMenu<String>(
          controller: controller,
          initialSelection: SettingsTranslated.choiceName(
            def.id,
            def.value<String>(),
          ),
          dropdownMenuEntries: [
            for (final choice
                in def.enum_?.choices?.toList() ?? const <SettingsChoice>[])
              DropdownMenuEntry(
                value: choice.value,
                label: SettingsTranslated.choiceName(def.id, choice.value),
                leadingIcon: (choice.icon?.isNotEmpty ?? false)
                    ? Iconify(choice.icon!, size: 18)
                    : null,
                labelWidget: _ChoiceLabel(def.id, choice),
              ),
          ],
          onSelected: (value) {
            if (value != null) unawaited(Settings.set<String>(def.id, value));
          },
        ),
      ),
    );
  }
}

/// Dropdown entry label showing the title and description.
class const _ChoiceLabel(final String id, final SettingsChoice choice)
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = SettingsTranslated.choiceName(id, choice.value);
    final description = choice.hasDescription == true
        ? SettingsTranslated.choiceDescription(id, choice.value)
        : "";

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        Text(name),
        if (description.isNotEmpty)
          Text(
            description,
            style: TextStyle(fontSize: 12, color: context.colors.textMuted),
          ),
      ],
    );
  }
}
