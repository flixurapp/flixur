import "dart:async";

import "package:flixur/routes/activity/index.dart";
import "package:flixur/routes/admin/index.dart";
import "package:flixur/routes/downloads/index.dart";
import "package:flixur/routes/explore/index.dart";
import "package:flixur/routes/home/index.dart";
import "package:flixur/routes/library/index.dart";
import "package:flixur/routes/search/index.dart";
import "package:flixur/routes/settings/index.dart";
import "package:flixur/ui/main_nav/bottom.dart";
import "package:flixur/ui/main_nav/rail.dart";
import "package:flixur/ui/main_nav/top.dart";
import "package:flixur/utils.dart";
import "package:flutter/services.dart";
import "package:material_ui/material_ui.dart";

const mainNavIconSize = 32.0;
const mainNavAnimationDuration = Duration(milliseconds: 200);

enum MainNavIDs {
  // default on navbar
  home,
  library,
  search,
  activity,
  explore,
  // default hidden
  downloads,
  admin,
  settings,
}

/// A single main navigation section.
class MainNavSection {
  const new({required this.id, required this.icon, required this.builder});

  // Unique ID for this section.
  final MainNavIDs id;

  /// Icon string to use for the route.
  final String icon;

  /// Page shown at the root route.
  final GoRouterWidgetBuilder builder;

  /// The enum name of this section's ID.
  String get name => id.name;

  /// Translated label for the section.
  String get label => t.navigation.section_titles[id.name] ?? "Unknown";

  /// Builds the shell branch hosting this section.
  StatefulShellBranch toBranch() {
    return StatefulShellBranch(
      routes: [GoRoute(name: name, path: "/$name", builder: builder)],
    );
  }
}

// all main nav sections
final mainNavSections = [
  MainNavSection(
    id: .home,
    icon: "house",
    builder: (context, state) => const HomeView(),
  ),
  MainNavSection(
    id: .library,
    icon: "folders",
    builder: (context, state) => const LibraryView(),
  ),
  MainNavSection(
    id: .search,
    icon: "magnifying-glass",
    builder: (context, state) => const SearchView(),
  ),
  MainNavSection(
    id: .activity,
    icon: "heartbeat",
    builder: (context, state) => const ActivityView(),
  ),
  MainNavSection(
    id: .explore,
    icon: "binoculars",
    builder: (context, state) => const ExploreView(),
  ),
  MainNavSection(
    id: .downloads,
    icon: "download-simple",
    builder: (context, state) => const DownloadsView(),
  ),
  MainNavSection(
    id: .admin,
    icon: "gavel",
    builder: (context, state) => const AdminView(),
  ),
  MainNavSection(
    id: .settings,
    icon: "gear",
    builder: (context, state) => const SettingsView(),
  ),
];

//TODO: wire into an actual setting
/// Which sections to render in the main nav.
const mainNavShownSections = [
  "home",
  "library",
  "search",
  "activity",
  "explore",
];

/// Resolves a list of string section IDs to a list of sections.
List<MainNavSection> resolveMainNavSections(List<String> ids) {
  // map the sections
  final byName = {for (final item in mainNavSections) item.name: item};
  return {
    // create a set with found sections
    for (final id in ids) ?byName[id],
    // convert to list
  }.toList();
}

/// Wrapper holding the main nav sections and the navbars.
class MainNavWrapper extends StatelessWidget {
  const new({required this.navShell, super.key});

  final StatefulNavigationShell navShell;

  MainNavIDs? get selected => sectionIDFromBranch(navShell.currentIndex);
  List<MainNavSection> get shownSections =>
      resolveMainNavSections(mainNavShownSections);
  List<MainNavSection> get hiddenSections => resolveMainNavSections([
    for (final section in mainNavSections)
      if (!mainNavShownSections.contains(section.name)) section.name,
  ]);

  @override
  Widget build(BuildContext context) {
    final shell = Column(
      crossAxisAlignment: .stretch,
      children: [
        const MainNavTop(),
        Expanded(child: navShell),
      ],
    );

    // landscape gets a side navbar instead of the bottom one
    if (context.isLandscape) {
      return Scaffold(
        body: Row(
          children: [
            MainNavRail(parent: this, onSelected: _onSelect),
            Expanded(child: shell),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: MainNavBottom(parent: this, onSelected: _onSelect),
    );
  }

  void _onSelect(MainNavSection section) {
    navShell.goBranch(
      // there should always be a branch index for any given ID
      branchIndexFromID(section.id)!,
      // re-selecting the active tab goes back its root
      initialLocation: section.id == selected,
    );
  }

  /// The section ID for a specific branch index.
  static MainNavIDs? sectionIDFromBranch(int index) =>
      index >= 0 && index < mainNavSections.length
      ? mainNavSections[index].id
      : null;

  /// Index of the branch holding [id], or null if it is invalid.
  static int? branchIndexFromID(MainNavIDs id) {
    final index = mainNavSections.indexWhere((item) => item.id == id);
    return index == -1 ? null : index;
  }
}

/// Mixin for the main nav parent.
mixin MainNavWidget {
  MainNavWrapper get parent;
  ValueChanged<MainNavSection> get onSelected;
}

/// Class for individual nav buttons.
abstract class MainNavItem extends StatelessWidget {
  const new({
    required this.parent,
    required this.section,
    required this.axis,
    super.key,
    this.width,
    this.height,
  });

  final MainNavWidget parent;
  final MainNavSection section;
  final Axis axis;

  final double? width;
  final double? height;

  bool get selected => parent.parent.selected == section.id;

  Widget builder(List<Widget> children) {
    return Semantics(
      label: section.label,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          parent.onSelected(section);
        },
        child: SizedBox(
          width: width,
          height: height,
          child: axis == .horizontal
              ? Column(mainAxisAlignment: .center, children: children)
              : Row(children: children),
        ),
      ),
    );
  }
}

/// Highlight element for selected navbar buttons.
class MainNavItemHighlighter extends StatelessWidget {
  const new({required this.axis, required this.enabled, super.key});

  /// Axis for the highlight to render on.
  final Axis axis;

  /// Whether or not the highlight should be applied.
  final bool enabled;

  static const double size = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedContainer(
        duration: mainNavAnimationDuration,
        width: axis == .vertical
            ? size
            : // horizontal
              (enabled ? constraints.maxWidth : 0),
        height: axis == .horizontal
            ? size
            : // vertical
              (enabled ? constraints.maxHeight : 0),
        decoration: BoxDecoration(
          color: enabled ? context.colors.primary : Colors.transparent,
        ),
      ),
    );
  }
}
