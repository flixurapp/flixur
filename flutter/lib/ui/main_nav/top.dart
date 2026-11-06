import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";

class MainNavTop extends StatelessWidget {
  const MainNavTop({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.mantle,
      child: SafeArea(
        child: SizedBox(
          height: MainNavRail.itemHeight,
          child: Column(
            children: [Expanded(child: const Text("Window Title"))],
          ),
        ),
      ),
    );
  }
}
