import "package:flixur/hooks.dart";
import "package:flixur/routes/settings/header.dart";
import "package:flixur/routes/settings/tiles/bool.dart";
import "package:flixur/routes/settings/tiles/enum.dart";
import "package:flixur/routes/settings/tiles/string.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsView({super.key}) extends HookWidget {
  /// Amount of padding to the left of setting items.
  static const tilePadding = 16.0;

  /// Gets the padding for a specific definition. Omit for x1.
  static double paddingFor(BuildContext context, [String? id]) =>
      (id == null ? 1 : id.split(".").length) *
      SettingsView.tilePadding *
      // halve the padding for mobile
      (context.isLandscape ? 1 : 0.5);

  @override
  Widget build(BuildContext context) {
    final searchTerm = useState("");
    // rebuild when any setting changes
    useSettings();

    final query = searchTerm.value.trim();

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SettingsViewHeader((value) => searchTerm.value = value),
        Expanded(
          child: query.isEmpty
              ? ListView(
                  padding: const .symmetric(horizontal: 16, vertical: 12),
                  children: _renderGroup(context, null),
                )
              : _SearchResults(query),
        ),
      ],
    );
  }
}

/// Renders search results as a flat list of tiles.
class const _SearchResults(final String query) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final results = useMemoized(() => Settings.searchIndex.search(query), [
      query,
      Settings.definitions,
    ]);

    return ListView(
      padding: const .symmetric(horizontal: 16, vertical: 12),
      children: [
        for (final result in results) ?_settingsTile(result.item, true),
      ],
    );
  }
}

/// Returns a setting tile for a given definition.
Widget? _settingsTile(SettingsDefinition def, [bool isSearching = false]) =>
    switch (def.kind) {
      .bool_ => SettingsTileBool(def, isSearching: isSearching),
      //.int_ => SettingsTileInt(def, search: search),
      //.float => SettingsTileFloat(def, search: search),
      .string => SettingsTileString(def, isSearching: isSearching),
      .enum_ => SettingsTileEnum(def, isSearching: isSearching),
      //.stringlist => SettingsTileStringList(def, search: search),
      _ => null,
    };

/// Render a group's settings, then its children.
List<Widget> _renderGroup(BuildContext context, String? parent) {
  // direct child settings
  final definitions = Settings.definitions ?? [];
  final children = _sortSettings([
    for (final def in definitions)
      if (parent != null && settingIDParent(def.id) == parent) def,
  ], (d) => (d.id, settingName(d.id), d.order));

  // child groups
  final groups = Settings.groups ?? [];
  final childGroups = _sortSettings([
    for (final group in groups)
      if (parent == null
          ? !group.id.contains(".")
          : settingIDParent(group.id) == parent)
        group,
  ], (g) => (g.id, settingGroupName(g.id), g.order));

  return [
    for (final def in children) ?_settingsTile(def),
    for (final group in childGroups) _GroupTile(group),
  ];
}

class const _GroupTile(final SettingsGroup group) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useExpansibleController();
    final expanded = useState(true);

    final colors = context.colors;
    final icon = group.icon;

    final bg = colors.crust;
    final shape = settingIDParent(group.id) == null
        ? const RoundedRectangleBorder(borderRadius: .all(.circular(8)))
        : const Border();

    return ExpansionTile(
      key: ValueKey(group.id),
      controller: controller,
      collapsedBackgroundColor: bg,
      backgroundColor: bg,
      initiallyExpanded: true,
      onExpansionChanged: (value) => expanded.value = value,
      trailing: AnimatedRotation(
        turns: expanded.value ? 0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: const Iconify("caret-down", size: 24),
      ),
      leading: icon == null || icon.isEmpty ? null : Iconify(icon),
      title: Text(
        settingGroupName(group.id),
        style: settingIDParent(group.id) == null
            ? const TextStyle(fontSize: 18, fontWeight: .w600)
            : null,
      ),
      shape: shape,
      collapsedShape: shape,
      // each child gets inset more
      tilePadding: .only(
        left: SettingsView.paddingFor(context, group.id),
        right: SettingsView.paddingFor(context),
      ),
      childrenPadding: const .only(bottom: 4),
      children: [..._renderGroup(context, group.id)],
    );
  }
}

/// Sorts a list of settings/groups ([items]).
/// [keysOf] is used to get the (ID, name, order) for each item.
List<T> _sortSettings<T>(
  List<T> items,
  (String, String, int) Function(T) keysOf,
) => items
  ..sort((a, b) {
    final (aId, aName, aOrder) = keysOf(a);
    final (bId, bName, bOrder) = keysOf(b);

    final order = aOrder.compareTo(bOrder);
    if (order != 0) return order;

    final name = aName.toLowerCase().compareTo(bName.toLowerCase());
    if (name != 0) return name;

    return aId.compareTo(bId);
  });
