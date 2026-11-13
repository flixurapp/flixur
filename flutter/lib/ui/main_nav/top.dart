import "dart:async";

import "package:flixur/router.dart" show router;
import "package:flixur/settings.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/buttons.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:material_ui/material_ui.dart";
import "package:window_manager/window_manager.dart";

class const MainNavTop({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final height = context.isLandscape ? 38.0 : 44.0;

    final moreMenuItems = [
      // show hidden buttons on mobile
      if (!context.isLandscape)
        for (final section in MainNavWrapper.hiddenSections)
          _MoreMenuItem(section: section),
      // debug size button
      if (kDebugMode && TitlebarManager.isSupported)
        _MoreMenuItem(
          section: null,
          label: t.titlebar.minimize,
          onPressed: TitlebarManager.debugResizeToPhone,
          foreground: context.colors.tertiary,
          iconName: "device-mobile",
        ),
    ];

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
                  builder: (context, _) => IconTheme(
                    data: const .new(size: mainNavIconSize * 0.8),
                    child: Row(
                      crossAxisAlignment: .stretch,
                      children: [
                        if (moreMenuItems.isNotEmpty)
                          ValueListenableBuilder(
                            valueListenable: MainNavWrapper.activeSection,
                            builder: (context, _, _) =>
                                SettingsValue<List<String>>(
                                  "ui.navigation.shownSections",
                                  builder: (context, _) =>
                                      _MoreMenu(children: moreMenuItems),
                                ),
                          ),
                        if (TitlebarManager.shouldEnable) ...[
                          _MainNavTopButton(
                            label: t.titlebar.minimize,
                            onTap: TitlebarManager.minimize,
                            square: !context.isLandscape,
                            child: const Iconify("minus"),
                          ),
                          _MainNavTopButton(
                            label: t.titlebar.maximize,
                            onTap: TitlebarManager.toggleMaximized,
                            square: !context.isLandscape,
                            child: ValueListenableBuilder(
                              valueListenable:
                                  TitlebarManager.isMaximizedNotifier,
                              builder: (context, maximized, _) => Iconify(
                                maximized ? "corners-in" : "corners-out",
                              ),
                            ),
                          ),
                          _MainNavTopButton(
                            label: t.titlebar.close,
                            onTap: TitlebarManager.close,
                            square: !context.isLandscape,
                            color: colors.error,
                            child: const Iconify("x"),
                          ),
                        ],
                      ],
                    ),
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
  final bool noForeground = false,
  final bool selected = false,
  final Color? color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: FlixurButton(
        tint: color,
        foregroundColor: noForeground ? null : color,
        icon: child,
        borderWidth: selected ? MainNavItemHighlighter.size : 0,
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
                child: const Iconify("caret-double-left"),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Popup menu holding more navigation options.
class const _MoreMenu({required final List<Widget> children})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MenuAnchor(
      style: .new(
        backgroundColor: .all(colors.crust),
        elevation: .all(6),
        padding: .all(.zero),
      ),
      menuChildren: children,
      builder: (context, controller, _) => _MainNavTopButton(
        label: t.titlebar.more,
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        square: true,
        color: colors.primary,
        noForeground: true,
        selected:
            !context.isLandscape &&
            MainNavWrapper.hiddenSections.contains(
              MainNavWrapper.activeSection.value,
            ),
        child: const Iconify("dots-three"),
      ),
    );
  }
}

/// Entry for a single item inside [_MoreMenu].
class const _MoreMenuItem({
  required final MainNavSection? section,
  final VoidCallback? onPressed,
  final String? iconName,
  final String? label,
  final Color? foreground,
}) extends StatelessWidget {
  bool get active =>
      section != null && MainNavWrapper.activeSection.value == section;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = foreground ?? (active ? colors.primary : colors.textMuted);

    return MenuItemButton(
      onPressed: () {
        unawaited(HapticFeedback.selectionClick());
        if (onPressed != null) {
          onPressed!();
        } else if (section != null) {
          router.goNamed(section!.name);
        }
      },
      leadingIcon: Iconify(iconName ?? section?.icon ?? ""),
      style: .new(
        padding: .all(const .symmetric(horizontal: 18, vertical: 24)),
        foregroundColor: .all(fg),
        iconColor: .all(fg),
        iconSize: .all(26),
        mouseCursor: .resolveWith(
          (s) => switch (s.mainState) {
            _ when s.has(.hovered) => SystemMouseCursors.click,
            _ => SystemMouseCursors.basic,
          },
        ),
      ),
      child: Text(
        label ?? section?.label ?? "",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
