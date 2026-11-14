import "dart:async";

import "package:flixur/hooks.dart";
import "package:flixur/routes/settings/tiles/common.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
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
    final controller = useTextEditingController(text: def.value<String>());

    // keep controller in sync
    final revision = useSettings([def.id]);
    useEffect(() {
      final value = def.value<String>();
      if (controller.text != value) controller.text = value;
      return null;
    }, [revision]);

    return LayoutBuilder(
      builder: (context, constraints) => SettingsTileShell(
        def,
        isSearching: isSearching,
        vertical: FlixurDropdownMenu<String>(
          controller: controller,
          initialSelection: def.value<String>(),
          dropdownMenuEntries: [
            for (final choice
                in def.enum_?.choices?.toList() ?? const <ChoiceSpec>[])
              DropdownMenuEntry(
                value: choice.value,
                label: choice.value,
                leadingIcon: (choice.icon?.isNotEmpty ?? false)
                    ? Iconify(choice.icon!, size: 18)
                    : null,
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
