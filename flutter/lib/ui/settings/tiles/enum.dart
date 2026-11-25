import "dart:async";

import "package:flixur/settings.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/settings/tiles/common.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flixur/ui/theme.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// An enum setting with fixed choices.
class const SettingsTileEnum(
  final SettingsDefinition def,
  final SettingsValues values, {
  final bool isSearching = false,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: SettingsTranslated.choiceName(
        def.id,
        values.getValue<String>(def.id),
        isServer: values.isServer,
      ),
    );

    // keep controller in sync
    final revision = useSettingsChanges(values, [def.id]);
    useEffect(() {
      final name = SettingsTranslated.choiceName(
        def.id,
        values.getValue<String>(def.id),
        isServer: values.isServer,
      );
      if (controller.text != name) controller.text = name;
      return null;
    }, [revision]);

    return LayoutBuilder(
      builder: (context, constraints) => SettingsTileShell(
        def,
        values,
        isSearching: isSearching,
        vertical: FlixurDropdownMenu<String>(
          controller: controller,
          initialSelection: SettingsTranslated.choiceName(
            def.id,
            values.getValue<String>(def.id),
            isServer: values.isServer,
          ),
          dropdownMenuEntries: [
            for (final choice
                in def.enum_?.choices?.toList() ?? const <SettingsChoice>[])
              DropdownMenuEntry(
                value: choice.value,
                label: SettingsTranslated.choiceName(
                  def.id,
                  choice.value,
                  isServer: values.isServer,
                ),
                leadingIcon: (choice.icon?.isNotEmpty ?? false)
                    ? Iconify(choice.icon!, size: 18)
                    : null,
                labelWidget: _ChoiceLabel(
                  def.id,
                  choice,
                  isServer: values.isServer,
                ),
              ),
          ],
          onSelected: (value) {
            if (value != null) unawaited(values.set<String>(def.id, value));
          },
        ),
      ),
    );
  }
}

/// Dropdown entry label showing the title and description.
class const _ChoiceLabel(
  final String id,
  final SettingsChoice choice, {
  required final bool isServer,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = SettingsTranslated.choiceName(
      id,
      choice.value,
      isServer: isServer,
    );
    final description = choice.hasDescription == true
        ? SettingsTranslated.choiceDescription(
            id,
            choice.value,
            isServer: isServer,
          )
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
