import "dart:async";
import "dart:math";

import "package:flixur/hooks.dart";
import "package:flixur/routes/settings/index.dart";
import "package:flixur/routes/settings/tiles/common.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// A string setting.
class const SettingsTileString(final SettingsDefinition def, {super.key})
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final debouncer = useFlixurDebounced(flushOnDispose: true);
    final focus = useFocusNode();
    final controller = useTextEditingController(text: def.value<String>());

    /// if the "show" button was clicked on the obscured text
    final showObscured = useState(false);

    // keep the controller in sync when the setting changes elsewhere
    final revision = useSettings([def.id]);
    useEffect(() {
      final value = def.value<String>();
      if (!focus.hasFocus && controller.text != value) controller.text = value;
      return null;
    }, [revision]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final input = FlixurInput(
          textField: (decoration) {
            final obscured = def.string?.secret ?? false;
            final maxLength = def.string?.maxLength;

            final suffixIcon = obscured || maxLength != null
                ? Padding(
                    padding: const .symmetric(horizontal: 4),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([controller, focus]),
                      builder: (context, _) =>
                          obscured && (maxLength == null || !focus.hasFocus)
                          // show/hide button
                          ? IconButton(
                              onPressed: () =>
                                  showObscured.value = !showObscured.value,
                              icon: showObscured.value
                                  ? const Iconify("eye-slash")
                                  : const Iconify("eye"),
                              style: .new(
                                iconColor: .all(context.colors.textMuted),
                              ),
                              tooltip: showObscured.value
                                  ? t.btn_hide
                                  : t.btn_show,
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
              obscureText: obscured && !showObscured.value,
              onChanged: (value) {
                final profileID = Settings.activeProfileID;
                debouncer.run(
                  () => unawaited(
                    Settings.set<String>(def.id, value, profileID: profileID),
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
        );

        return SettingsTileShell(
          def,
          vertical: context.isLandscape
              ? SizedBox(
                  width: max(
                    200,
                    (constraints.maxWidth * 0.4) -
                        SettingsView.paddingFor(context, def.id),
                  ),
                  child: input,
                )
              : input,
        );
      },
    );
  }
}
