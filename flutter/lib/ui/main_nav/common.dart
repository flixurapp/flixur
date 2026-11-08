import "dart:async";

import "package:flixur/routes/activity/index.dart";
import "package:flixur/routes/admin/index.dart";
import "package:flixur/routes/downloads/index.dart";
import "package:flixur/routes/explore/index.dart";
import "package:flixur/routes/home/index.dart";
import "package:flixur/routes/library/index.dart";
import "package:flixur/routes/search/index.dart";
import "package:flixur/routes/settings/index.dart";
import "package:flixur/titlebar.dart";
import "package:flixur/ui/main_nav/bottom.dart";
import "package:flixur/ui/main_nav/rail.dart";
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
class MainNavSection({
  // Unique ID for this section.
  required final MainNavIDs id,

  /// Icon string to use for the route.
  required final String icon,

  /// Page shown at the root route.
  required final GoRouterWidgetBuilder builder,
}) {
  /// The enum name of this section's ID.
  String get name => id.name;

  /// Translated label for the section.
  String get label => t.navigation.section_titles[id.name] ?? "Unknown";

  /// Title slot for this section.
  final titleSlot = PageTitleSlot();

  /// Builds the shell branch hosting this section.
  StatefulShellBranch toBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          name: name,
          path: "/$name",
          builder: (context, state) =>
              // wrap the brandh in the title scope
              PageTitleScope(slot: titleSlot, child: builder(context, state)),
        ),
      ],
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
class const MainNavWrapper({
  required final StatefulNavigationShell navShell,
  super.key,
}) extends StatelessWidget {
  /// The currently selected section.
  static final ValueNotifier<MainNavSection?> activeSection =
      ValueNotifier<MainNavSection?>(null);

  /// Title slot for pages that dont have a section-specific title.
  static final titleSlot = PageTitleSlot();

  /// The current page/window title.
  static final ValueNotifier<String> pageTitle = _createMainNavTitle();

  MainNavIDs? get selected => sectionIDFromBranch(navShell.currentIndex);
  List<MainNavSection> get shownSections =>
      resolveMainNavSections(mainNavShownSections);
  List<MainNavSection> get hiddenSections => resolveMainNavSections([
    for (final section in mainNavSections)
      if (!mainNavShownSections.contains(section.name)) section.name,
  ]);

  @override
  Widget build(BuildContext context) {
    _syncActiveSection();

    // landscape gets a side navbar instead of the bottom one
    if (context.isLandscape) {
      return Scaffold(
        body: Row(
          children: [
            MainNavRail(parent: this, onSelected: _onSelect),
            Expanded(child: navShell),
          ],
        ),
      );
    }

    // mobile layout
    return Scaffold(
      body: navShell,
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

  /// Syncs the active section to the notifier.
  void _syncActiveSection() {
    final section = sectionFromID(sectionIDFromBranch(navShell.currentIndex));
    if (identical(activeSection.value, section)) return;

    runAfterFrame(() {
      if (!identical(activeSection.value, section)) {
        activeSection.value = section;
      }
    });
  }

  /// The section for [id], or null if it doesn't exist.
  static MainNavSection? sectionFromID(MainNavIDs? id) {
    for (final section in mainNavSections) {
      if (section.id == id) return section;
    }
    return null;
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

/// Keeps [MainNavWrapper.pageTitle] updated.
ValueNotifier<String> _createMainNavTitle() {
  final notifier = ValueNotifier<String>(t.app_name);
  ValueNotifier<String?>? listened;

  /// Updates the current window title.
  void update() {
    final section = MainNavWrapper.activeSection.value;
    final title =
        // main page title
        MainNavWrapper.titleSlot.value ??
        // active section page title or label
        (section?.titleSlot.value ?? section?.label) ??
        // fallback to app name
        t.app_name;
    if (notifier.value != title) notifier.value = title;
  }

  /// Re-listsns to the new active section title.
  void sync() {
    listened?.removeListener(update);
    listened = MainNavWrapper.activeSection.value?.titleSlot;
    listened?.addListener(update);
    update();
  }

  MainNavWrapper.titleSlot.addListener(update);
  MainNavWrapper.activeSection.addListener(sync);
  sync();
  return notifier;
}

/// Mixin for the main nav parent.
abstract class const MainNavWidget({
  required final MainNavWrapper parent,
  required final ValueChanged<MainNavSection> onSelected,
  super.key,
}) extends StatelessWidget;

/// Class for individual nav buttons.
abstract class const MainNavItem({
  required final MainNavWidget parent,
  required final MainNavSection section,
  required final Axis axis,
  super.key,
  final double? width,
  final double? height,
}) extends StatelessWidget {
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
class const MainNavItemHighlighter({
  /// Axis for the highlight to render on.
  required final Axis axis,

  /// Whether or not the highlight should be applied.
  required final bool enabled,
  super.key,
}) extends StatelessWidget {
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
