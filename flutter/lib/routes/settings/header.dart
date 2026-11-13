import "dart:async";

import "package:flixur/api.dart";
import "package:flixur/hooks.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/buttons.dart";
import "package:flixur/ui/dialogs.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// Border width of the bottom of the top buttons.
const double _topBorderWidth = 2;

class const SettingsViewHeader(
  final void Function(String) onChanged, {
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useSettings([]);

    final activeName = Settings.profile(Settings.activeProfileID ?? "")?.name;
    final profileController = useTextEditingController();
    useEffect(() {
      final text = activeName ?? "";
      if (profileController.text != text) {
        profileController.value = .new(text: text);
      }
      return null;
    }, [activeName]);

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
                  borderSide: .new(
                    color: Colors.transparent,
                    width: _topBorderWidth,
                  ),
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
                    controller: profileController,
                    searchCallback: (entries, text) =>
                        entries.indexWhere((entry) => entry.label == text),
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
                const _SyncButton(),
                FlixurButton(
                  onPressed: () => _createProfile(context),
                  borderWidth: _topBorderWidth,
                  tint: colors.success,
                  icon: const Iconify("plus"),
                  label: context.isLandscape ? Text(t.btn_new) : null,
                ),
                FlixurButton(
                  onPressed: () => _renameProfile(context),
                  borderWidth: _topBorderWidth,
                  tint: colors.primary,
                  icon: const Iconify("pencil-simple"),
                  label: context.isLandscape ? Text(t.btn_rename) : null,
                ),
                FlixurButton(
                  onPressed: (Settings.profiles?.length ?? 0) > 1
                      ? () => _deleteProfile(context)
                      : null,
                  borderWidth: _topBorderWidth,
                  tint: colors.error,
                  icon: const Iconify("trash-simple"),
                  label: context.isLandscape ? Text(t.btn_delete) : null,
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
      case ApiFailure(:final translated):
        await showErrorDialog(
          context,
          title: t.api_request_fail,
          message: translated(t.routes.settings.create_rename_codes),
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
        await showErrorDialog(
          context,
          title: t.api_request_fail,
          message: message,
        );
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
        await showErrorDialog(
          context,
          title: t.api_request_fail,
          message: message,
        );
    }
  }
}

class const _SyncButton() extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useListenable(Settings.syncState).value;

    final spin = useAnimationController(
      duration: const Duration(seconds: 1),
      keys: const [],
    );
    useEffect(() {
      if (state case SyncSyncing()) {
        spin.repeat();
        return spin.stop;
      }
      spin.value = 0;
      return null;
    }, [state]);

    final (icon, color, tooltip) = switch (state) {
      SyncOffline() => (
        "cloud-slash",
        context.colors.error,
        t.routes.settings.sync_offline as String?,
      ),
      SyncError(:final message) => (
        "exclamation-mark",
        context.colors.warn,
        message,
      ),
      _ => ("arrows-clockwise", null, null),
    };

    return FlixurButton(
      onPressed: () => unawaited(Settings.sync()),
      tint: color,
      borderWidth: _topBorderWidth,
      icon: GatedWidget(
        gate: tooltip != null,
        wrapper: (child) => Tooltip(message: tooltip, child: child),
        child: RotationTransition(
          turns: spin,
          child: Iconify(icon, color: color),
        ),
      ),
    );
  }
}
