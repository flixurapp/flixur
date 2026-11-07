import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

class const MainNavTop({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = context.isLandscape ? 38.0 : 44.0;

    return Material(
      color: colors.mantle,
      child: SafeArea(
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              // nav rail expand/collapse toggle
              if (context.isLandscape)
                ValueListenableBuilder(
                  valueListenable: MainNavRail.isExpanded,
                  builder: (context, expanded, _) => Semantics(
                    button: true,
                    label: expanded
                        ? t.navigation.rail.collapse
                        : t.navigation.rail.expand,
                    child: InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () => MainNavRail.isExpanded.value =
                          !MainNavRail.isExpanded.value,
                      child: SizedBox(
                        width: MainNavRail.collapsedWidth,
                        height: MainNavRail.itemHeight,
                        child: AnimatedRotation(
                          duration: mainNavAnimationDuration,
                          turns: expanded ? 0 : -1 / 2,
                          child: Iconify(
                            "caret-double-left",
                            size: mainNavIconSize * 0.8,
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const Expanded(child: Center(child: Text("Window Title"))),
            ],
          ),
        ),
      ),
    );
  }
}
