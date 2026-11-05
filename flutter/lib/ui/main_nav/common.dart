import "package:flixur/routes/activity/index.dart";
import "package:flixur/routes/admin/index.dart";
import "package:flixur/routes/downloads/index.dart";
import "package:flixur/routes/explore/index.dart";
import "package:flixur/routes/home/index.dart";
import "package:flixur/routes/library/index.dart";
import "package:flixur/routes/search/index.dart";
import "package:flixur/routes/settings/index.dart";
import "package:flixur/ui/main_nav/bottom.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";

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
  const MainNavSection({
    required this.id,
    required this.icon,
    required this.builder,
  });

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
  "activity",
  "library",
  "search",
  "explore",
  "downloads",
  "admin",
  "settings",
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
  const MainNavWrapper({required this.navShell, super.key});

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
    return Scaffold(
      body: navShell,
      bottomNavigationBar: MainNavBottom(
        parent: this,
        onSelected: (destination) => navShell.goBranch(
          // there should always be a branch index for any given ID
          branchIndexFromID(destination.id)!,
          // re-selecting the active tab goes back its root
          initialLocation:
              destination.id == sectionIDFromBranch(navShell.currentIndex),
        ),
      ),
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
