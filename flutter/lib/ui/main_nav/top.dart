import "package:flixur/titlebar.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:window_manager/window_manager.dart";

class const MainNavTop({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = context.isLandscape ? 38.0 : 44.0;

    return DragToMoveArea(
      child: Material(
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
                    builder: (context, expanded, _) => _MainNavTopButton(
                      label: expanded
                          ? t.titlebar.rail_collapse
                          : t.titlebar.rail_expand,
                      onTap: () => MainNavRail.isExpanded.value =
                          !MainNavRail.isExpanded.value,
                      child: AnimatedRotation(
                        duration: mainNavAnimationDuration,
                        turns: expanded ? 0 : -1 / 2,
                        child: const _MainNavTopIcon("caret-double-left"),
                      ),
                    ),
                  ),
                const Spacer(),
                const Text("Window Title"),
                const Spacer(),
                Row(
                  children: [
                    _MainNavTopButton(
                      label: t.titlebar.minimize,
                      onTap: TitlebarManager.minimize,
                      child: const _MainNavTopIcon("minus"),
                    ),
                    _MainNavTopButton(
                      label: t.titlebar.maximize,
                      onTap: TitlebarManager.toggleMaximized,
                      child: _MainNavTopIcon(
                        TitlebarManager.isMaximized
                            ? "corners-in"
                            : "corners-out",
                      ),
                    ),
                    _MainNavTopButton(
                      label: t.titlebar.close,
                      onTap: TitlebarManager.close,
                      child: const _MainNavTopIcon("x"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class const _MainNavTopButton({
  required final String label,
  required final VoidCallback onTap,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: onTap,
        child: SizedBox(
          width: MainNavRail.collapsedWidth,
          height: MainNavRail.itemHeight,
          child: child,
        ),
      ),
    );
  }
}

class const _MainNavTopIcon(final String name) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Iconify(
      name,
      size: mainNavIconSize * 0.8,
      color: context.colors.textMuted,
    );
  }
}
