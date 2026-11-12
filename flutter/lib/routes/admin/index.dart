import "package:flixur/api.dart";
import "package:material_ui/material_ui.dart";

class const AdminView({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialButton(onPressed: Api.logout, child: Text("logout"));
  }
}
