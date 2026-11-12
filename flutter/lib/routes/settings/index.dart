import "package:flixur/routes/settings/header.dart";
import "package:flixur/settings.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

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
          SettingsViewHeader((value) => setState(() => _searchTerm = value)),
        ],
      ),
    );
  }
}
