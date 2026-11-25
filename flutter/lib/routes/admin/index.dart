import "dart:async";

import "package:flixur/routes/admin/server_settings.dart";
import "package:flixur/ui/buttons.dart";
import "package:flixur/ui/dialogs.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/settings/menu.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";

class const AdminView({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useMemoized(ServerSettingsValues.new, const []);
    final searchTerm = useState("");
    final searchFocus = useFocusNode();

    // refetch/focus on root tap
    final rootTap = MainNavWrapper.sectionFromID(.admin)?.rootTapSignal;
    useEffect(() {
      if (rootTap == null) return null;

      void load({bool firstTime = false}) {
        unawaited(store.load());
        if (!firstTime) searchFocus.requestFocus();
      }

      load(firstTime: true);
      rootTap.addListener(load);
      return () => rootTap.removeListener(load);
    }, [rootTap, store]);

    // alert on errors
    final writeError = store.writeError;
    useEffect(() {
      void listener() {
        final message = writeError.value;
        if (message == null) return;
        writeError.value = null;
        unawaited(
          showErrorDialog(context, title: t.api_request_fail, message: message),
        );
      }

      writeError.addListener(listener);
      return () => writeError.removeListener(listener);
    }, [writeError]);

    final pushing = useListenable(store.pushing).value;
    final loading = useListenable(store.loading).value;
    final loadErrorMessage = useListenable(store.loadError).value;
    final query = searchTerm.value.trim();

    Widget body;
    if (loading && store.definitions.isEmpty) {
      body = const Center(child: LoadingSpinner());
    } else if (loadErrorMessage != null && store.definitions.isEmpty) {
      body = Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            Text(
              loadErrorMessage,
              style: TextStyle(color: context.colors.error),
            ),
            IntrinsicWidth(
              child: FlixurFloatingButton(
                onPressed: () => unawaited(store.load()),
                icon: const Iconify("arrows-clockwise"),
                label: Text(t.btn_retry),
              ),
            ),
          ],
        ),
      );
    } else {
      body = SettingsMenu(store, query: query);
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        TextField(
          textAlignVertical: .center,
          onChanged: (value) => searchTerm.value = value,
          decoration: InputDecoration(
            prefixIcon: Container(
              width: 48,
              height: 48,
              alignment: .center,
              child: pushing > 0
                  ? const LoadingSpinner()
                  : const Iconify("magnifying-glass"),
            ),
            hintText: t.routes.settings.search_hint,
            filled: true,
            fillColor: context.colors.mantle,
            border: const UnderlineInputBorder(borderRadius: .zero),
            enabledBorder: const UnderlineInputBorder(
              borderSide: .new(color: Colors.transparent, width: 2),
              borderRadius: .zero,
            ),
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}
