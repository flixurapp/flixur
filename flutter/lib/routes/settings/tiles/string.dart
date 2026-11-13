import "dart:async";
import "dart:math";

import "package:flixur/routes/settings/index.dart";
import "package:flixur/routes/settings/tiles/common.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// A string setting.
class const SettingsTileString(final SettingsDefinition def, {super.key})
    extends StatefulWidget {
  @override
  State<SettingsTileString> createState() => _State();
}

class _State extends State<SettingsTileString> {
  final debouncer = Debounced(flushOnDispose: true);
  final focus = FocusNode();
  late final controller = TextEditingController(
    text: widget.def.value<String>(),
  );

  @override
  void initState() {
    super.initState();
    Settings.changeNotifier.addListener(_syncValue);
  }

  void _syncValue() {
    final value = widget.def.value<String>();
    if (!focus.hasFocus && controller.text != value) controller.text = value;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SettingsTileShell(
      widget.def,
      vertical: SizedBox(
        width: !context.isLandscape
            ? constraints.maxWidth
            : max(
                200,
                (constraints.maxWidth / 3) -
                    SettingsView.paddingFor(context, widget.def.id),
              ),
        child: FlixurInput(
          textField: (decoration) => TextField(
            controller: controller,
            focusNode: focus,
            decoration: decoration,
            onChanged: (value) {
              final profileID = Settings.activeProfileID;
              debouncer.run(
                () => unawaited(
                  Settings.set<String>(
                    widget.def.id,
                    value,
                    profileID: profileID,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    Settings.changeNotifier.removeListener(_syncValue);
    debouncer.dispose();
    controller.dispose();
    focus.dispose();
    super.dispose();
  }
}
