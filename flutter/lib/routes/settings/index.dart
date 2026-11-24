import "package:flixur/routes/settings/header.dart";
import "package:flixur/ui/settings/menu.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";

class const SettingsView({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final searchTerm = useState("");

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SettingsViewHeader((value) => searchTerm.value = value),
        Expanded(
          child: SettingsMenu(
            clientSettingsValues,
            query: searchTerm.value.trim(),
          ),
        ),
      ],
    );
  }
}
