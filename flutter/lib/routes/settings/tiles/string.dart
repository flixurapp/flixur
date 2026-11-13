import "dart:async";
import "dart:math";

import "package:flixur/routes/settings/index.dart";
import "package:flixur/routes/settings/tiles/common.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
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

  /// If the "show" button was clicked on the obscured text.
  bool _showObscured = false;

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
  void dispose() {
    Settings.changeNotifier.removeListener(_syncValue);
    debouncer.dispose();
    controller.dispose();
    focus.dispose();
    super.dispose();
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
          textField: (decoration) {
            final obscured = widget.def.string?.secret ?? false;
            final maxLength = widget.def.string?.maxLength;

            final suffixIcon = obscured || maxLength != null
                ? Padding(
                    padding: const .symmetric(horizontal: 4),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([controller, focus]),
                      builder: (context, _) =>
                          obscured && (maxLength == null || !focus.hasFocus)
                          // show/hide button
                          ? IconButton(
                              mouseCursor: SystemMouseCursors.click,
                              onPressed: () => setState(
                                () => _showObscured = !_showObscured,
                              ),
                              icon: _showObscured
                                  ? const Iconify("eye-slash")
                                  : const Iconify("eye"),
                              style: .new(
                                iconColor: .all(context.colors.textMuted),
                              ),
                            )
                          // character counter
                          : IntrinsicWidth(
                              child: Container(
                                padding: const .directional(end: 2),
                                alignment: .bottomEnd,
                                child: Text(
                                  "${controller.text.characters.length}/$maxLength",
                                  style: TextStyle(
                                    color: context.colors.textMuted,
                                    fontSize: 12,
                                  ),
                                  textAlign: .center,
                                ),
                              ),
                            ),
                    ),
                  )
                : null;

            return TextField(
              controller: controller,
              focusNode: focus,
              maxLength: maxLength,
              decoration: decoration.copyWith(suffixIcon: suffixIcon),
              obscureText: obscured && !_showObscured,
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
              // remove default character counter
              buildCounter: (
                _, {
                required currentLength,
                required isFocused,
                maxLength,
              }) => null,
            );
          },
        ),
      ),
    ),
  );
}
