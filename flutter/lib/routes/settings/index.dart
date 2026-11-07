import "package:flixur/api.dart";
import "package:material_ui/material_ui.dart";

class SettingsView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text("settings page"),
        MaterialButton(onPressed: Api.logout, child: Text("logout")),
      ],
    );
  }
}
