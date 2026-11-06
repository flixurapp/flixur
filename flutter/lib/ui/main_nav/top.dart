import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

class MainNavTop extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.mantle,
      child: const SafeArea(
        child: SizedBox(
          height: MainNavRail.itemHeight,
          child: Column(children: [Expanded(child: Text("Window Title"))]),
        ),
      ),
    );
  }
}
