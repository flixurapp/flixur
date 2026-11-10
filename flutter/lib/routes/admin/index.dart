import "package:flixur/api.dart";
import "package:material_ui/material_ui.dart";

class AdminView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialButton(onPressed: Api.logout, child: Text("logout"));
  }
}
