import "package:flixur/settings.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/buttons.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/utils.dart";
import "package:flutter/foundation.dart";
import "package:material_ui/material_ui.dart";
import "package:window_manager/window_manager.dart";

class const MainNavTop({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = context.isLandscape ? 38.0 : 44.0;

    return Material(
      color: colors.mantle,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // window title / dragger
              GatedWidget(
                gate: TitlebarManager.isSupported,
                wrapper: (child) => DragToMoveArea(child: child),
                child: Align(
                  alignment: context.isLandscape ? .center : .centerStart,
                  child: Padding(
                    padding: const .symmetric(horizontal: 12),
                    child: ValueListenableBuilder(
                      valueListenable: MainNavWrapper.pageTitle,
                      builder: (context, title, _) => Text(
                        title,
                        style: .new(fontSize: context.isLandscape ? 14 : 16),
                      ),
                    ),
                  ),
                ),
              ),
              // (left) nav rail expand/collapse toggle
              const Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: _RailToggle(),
              ),
              // (right) window manager buttons
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SettingsValue<bool>(
                  "ui.window.useCustom",
                  builder: (context, _) => Row(
                    crossAxisAlignment: .stretch,
                    children: [
                      if (kDebugMode)
                        _MainNavTopButton(
                          label: t.titlebar.minimize,
                          onTap: TitlebarManager.debugResizeToPhone,
                          square: !context.isLandscape,
                          color: context.colors.tertiary,
                          child: const _MainNavTopIcon("device-mobile"),
                        ),
                      if (TitlebarManager.shouldEnable) ...[
                        _MainNavTopButton(
                          label: t.titlebar.minimize,
                          onTap: TitlebarManager.minimize,
                          square: !context.isLandscape,
                          child: const _MainNavTopIcon("minus"),
                        ),
                        _MainNavTopButton(
                          label: t.titlebar.maximize,
                          onTap: TitlebarManager.toggleMaximized,
                          square: !context.isLandscape,
                          child: ValueListenableBuilder(
                            valueListenable:
                                TitlebarManager.isMaximizedNotifier,
                            builder: (context, maximized, _) => _MainNavTopIcon(
                              maximized ? "corners-in" : "corners-out",
                            ),
                          ),
                        ),
                        _MainNavTopButton(
                          label: t.titlebar.close,
                          onTap: TitlebarManager.close,
                          square: !context.isLandscape,
                          color: colors.error,
                          child: const _MainNavTopIcon("x"),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
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
  final bool square = false,
  final Color? color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: FlixurButton(
        tint: color,
        foregroundColor: color,
        icon: child,
        onPressed: onTap,
        size: .new(
          square ? MainNavRail.itemHeight : MainNavRail.collapsedWidth,
          MainNavRail.itemHeight,
        ),
      ),
    );
  }
}

/// Nav rail toggle button.
class const _RailToggle() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MainNavWrapper.activeSection,
      builder: (context, section, _) => ValueListenableBuilder(
        valueListenable: MainNavWrapper.titleSlot,
        builder: (context, outerTitle, _) {
          // only show while the shell rail is actually visible
          if (!context.isLandscape || section == null || outerTitle != null) {
            return const SizedBox.shrink();
          }

          return ValueListenableBuilder(
            valueListenable: MainNavRail.isExpanded,
            builder: (context, expanded, _) => _MainNavTopButton(
              label: expanded
                  ? t.titlebar.rail_collapse
                  : t.titlebar.rail_expand,
              onTap: () =>
                  MainNavRail.isExpanded.value = !MainNavRail.isExpanded.value,
              child: AnimatedRotation(
                duration: mainNavAnimationDuration,
                turns: expanded ? 0 : -1 / 2,
                child: const _MainNavTopIcon("caret-double-left"),
              ),
            ),
          );
        },
      ),
    );
  }
}

class const _MainNavTopIcon(final String name) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Iconify(name, size: mainNavIconSize * 0.8);
  }
}
