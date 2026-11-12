import "dart:async";

import "package:flixur/api.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/buttons.dart";
import "package:flixur/ui/dialogs.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsViewHeader(
  final void Function(String) onChanged, {
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IntrinsicHeight(
      child: Flex(
        direction: context.isLandscape ? .horizontal : .vertical,
        crossAxisAlignment: .stretch,
        children: [
          Expanded(
            child: TextField(
              textAlignVertical: .center,
              onChanged: onChanged,
              decoration: InputDecoration(
                // hate hate hate hate
                prefixIcon: Container(
                  width: 48,
                  height: 48,
                  alignment: .center,
                  child: const Iconify("magnifying-glass"),
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
                      border: const UnderlineInputBorder(borderRadius: .zero),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: .new(color: Colors.transparent),
                        borderRadius: .zero,
                      ),
                    ),
                    dropdownMenuEntries: [
                      for (final profile
                          in Settings.profiles ?? const <SettingProfileBody>[])
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
                  onPressed: () => _createProfile(context),
                  borderWidth: 2,
                  tint: colors.success,
                  icon: const Iconify("plus"),
                  label: context.isLandscape ? null : Text(t.btn_new),
                ),
                FlixurButton(
                  onPressed: () => _renameProfile(context),
                  borderWidth: 2,
                  tint: colors.primary,
                  icon: const Iconify("pencil-simple"),
                  label: context.isLandscape ? null : Text(t.btn_rename),
                ),
                FlixurButton(
                  onPressed: (Settings.profiles?.length ?? 0) > 1
                      ? () => _deleteProfile(context)
                      : null,
                  borderWidth: 2,
                  tint: colors.error,
                  icon: const Iconify("trash-simple"),
                  label: context.isLandscape ? null : Text(t.btn_delete),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createProfile(BuildContext context) async {
    final name = await showPromptDialog(
      context,
      title: t.routes.settings.new_profile,
      submitText: t.btn_create,
      maxLength: 100,
    );
    if (name == null) return;

    final response = await Api.request(
      (a) => a.getSettingsApi().createSettingsProfile(
        createSettingsProfileRequest: .new((b) => b.name = name),
      ),
    );
    if (!context.mounted) return;
    switch (response) {
      case ApiSuccess(:final data):
        await Settings.sync();
        // select newly created profile
        await Settings.switchProfile(data.id);
      case ApiFailure(:final message):
        await showErrorDialog(
          context,
          title: t.routes.settings.new_profile,
          message: message,
        );
    }
  }

  Future<void> _renameProfile(BuildContext context) async {
    final profile = Settings.profile(Settings.activeProfileID ?? "");
    if (profile == null) return;

    final name = await showPromptDialog(
      context,
      title: t.btn_rename,
      submitText: t.btn_save,
      maxLength: 100,
      hintText: profile.name,
    );
    if (name == null) return;

    final response = await Api.request(
      (a) => a.getSettingsApi().renameSettingsProfile(
        profile: profile.id,
        renameSettingsProfileRequest: RenameSettingsProfileRequest(
          (b) => b..name = name,
        ),
      ),
    );
    if (!context.mounted) return;
    switch (response) {
      case ApiSuccess():
        await Settings.sync();
      case ApiFailure(:final message):
        await showErrorDialog(context, title: t.btn_rename, message: message);
    }
  }

  Future<void> _deleteProfile(BuildContext context) async {
    final profile = Settings.profile(Settings.activeProfileID ?? "");
    if (profile == null) return;
    if (!await showConfirmDialog(context, okText: t.btn_delete)) return;

    final response = await Api.request(
      (a) => a.getSettingsApi().deleteSettingsProfile(profile: profile.id),
    );
    if (!context.mounted) return;
    switch (response) {
      case ApiSuccess():
        await Settings.sync();
      case ApiFailure(:final message):
        await showErrorDialog(context, title: t.btn_delete, message: message);
    }
  }
}
