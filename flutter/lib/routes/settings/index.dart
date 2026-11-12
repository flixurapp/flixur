import "dart:async";

import "package:flixur/settings.dart";
import "package:flixur/ui/buttons.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsView({super.key}) extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _searchTerm = "";

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ValueListenableBuilder(
      valueListenable: Settings.changeNotifier,
      builder: (context, _, _) => Column(
        crossAxisAlignment: .stretch,
        children: [
          // search bar / profiles
          IntrinsicHeight(
            child: Flex(
              direction: context.isLandscape ? .horizontal : .vertical,
              crossAxisAlignment: .stretch,
              children: [
                Expanded(
                  child: TextField(
                    textAlignVertical: .center,
                    onChanged: (value) => setState(() => _searchTerm = value),
                    decoration: InputDecoration(
                      prefixIcon: SizedBox(
                        width: 48,
                        height: 48,
                        child: Iconify("magnifying-glass", color: colors.text),
                      ),
                      hintText: t.routes.settings.search_hint,
                      filled: true,
                      fillColor: colors.mantle,
                      border: const UnderlineInputBorder(borderRadius: .zero),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: .new(color: Colors.transparent),
                        borderRadius: .zero,
                      ),
                    ),
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    children: [
                      GatedWidget(
                        gate: !context.isLandscape,
                        wrapper: (child) => Expanded(child: child),
                        child: FlixurDropdownMenu(
                          initialSelection: Settings.activeProfileID,
                          expandedInsets: context.isLandscape ? null : .zero,
                          requestFocusOnTap: false,
                          inputDecorationTheme: InputDecorationThemeData(
                            filled: true,
                            fillColor: colors.mantle,
                            border: const UnderlineInputBorder(
                              borderRadius: .zero,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: .new(color: Colors.transparent),
                              borderRadius: .zero,
                            ),
                          ),
                          dropdownMenuEntries: [
                            for (final profile
                                in Settings.profiles ??
                                    const <SettingProfileBody>[])
                              DropdownMenuEntry(
                                value: profile.id,
                                label: profile.name,
                              ),
                          ],
                          onSelected: (id) {
                            if (id != null) {
                              unawaited(Settings.switchProfile(id));
                            }
                          },
                        ),
                      ),
                      FlixurButton(
                        onPressed: () {},
                        borderWidth: 2,
                        tint: colors.success,
                        icon: const Iconify("plus"),
                        label: context.isLandscape ? null : Text(t.btn_new),
                      ),
                      FlixurButton(
                        onPressed: () {},
                        borderWidth: 2,
                        tint: colors.primary,
                        icon: const Iconify("pencil"),
                        label: context.isLandscape ? null : Text(t.btn_rename),
                      ),
                      FlixurButton(
                        onPressed: (Settings.profiles?.length ?? 0) > 1
                            ? () {}
                            : null,
                        borderWidth: 2,
                        tint: colors.error,
                        icon: const Iconify("trash"),
                        label: context.isLandscape ? null : Text(t.btn_delete),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
