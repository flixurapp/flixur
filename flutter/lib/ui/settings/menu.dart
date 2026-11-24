import "package:flixur/hooks.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/settings/tiles/bool.dart";
import "package:flixur/ui/settings/tiles/enum.dart";
import "package:flixur/ui/settings/tiles/number.dart";
import "package:flixur/ui/settings/tiles/string.dart";
import "package:flixur/ui/settings/tiles/string_list.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fuse_dart/fuse_dart.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// Renders a settings menu for [values].
class const SettingsMenu(
  final SettingsValues values, {
  required final String query,
  super.key,
}) extends HookWidget {
  /// Amount of padding to the left of setting items.
  static const tilePadding = 16.0;

  /// Gets the padding for a specific definition. Omit for x1.
  static double paddingFor(BuildContext context, [String? id]) =>
      (id == null ? 1 : id.split(".").length) *
      tilePadding *
      // halve the padding for mobile
      (context.isLandscape ? 1 : 0.5);

  @override
  Widget build(BuildContext context) {
    // rebuild when any setting changes
    useSettingsChanges(values);

    return query.isEmpty
        ? ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12) +
                context.safeBottomPadding,
            children: _renderGroup(context, values, null),
          )
        : _SearchResults(values, query);
  }
}

/// Renders search results as a flat list of tiles.
class const _SearchResults(final SettingsValues values, final String query)
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final index = useMemoized(() => _buildSearchIndex(values.definitions), [
      values.definitions,
    ]);
    final results = useMemoized(() => index.search(query), [index, query]);

    return ListView(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12) +
          context.safeBottomPadding,
      children: [
        for (final result in results) ?_settingsTile(values, result.item, true),
      ],
    );
  }
}

/// Builds a fuzzy search index for the given definitions.
Fuse<SettingsDefinition> _buildSearchIndex(
  List<SettingsDefinition> definitions,
) => Fuse(
  definitions,
  options: .new(
    includeScore: true,
    useTokenSearch: true,
    keys: <FuseKey<SettingsDefinition>>[
      .new(
        name: "title",
        weight: 5,
        getFn: (d) => SettingsTranslated.defName(d.id),
      ),
      .new(
        name: "description",
        weight: 4,
        getFn: (d) => SettingsTranslated.defDescription(d.id),
      ),
      .new(name: "id", weight: 2, getFn: (d) => d.id),
      .new(
        name: "parents",
        weight: 1,
        // all of the group path segments joined into one string
        getFn: (d) => SettingsTranslated.groupSegments(d.id).join("\n"),
      ),
    ],
  ),
);

/// Returns a setting tile for a given definition.
Widget? _settingsTile(
  SettingsValues values,
  SettingsDefinition def, [
  bool isSearching = false,
]) => switch (def.kind) {
  .bool_ => SettingsTileBool(def, values, isSearching: isSearching),
  .int_ || .float => SettingsTileNumber(def, values, isSearching: isSearching),
  .string => SettingsTileString(def, values, isSearching: isSearching),
  .enum_ => SettingsTileEnum(def, values, isSearching: isSearching),
  .stringlist => SettingsTileStringList(def, values, isSearching: isSearching),
  _ => null,
};

/// Render a group's settings, then its children.
List<Widget> _renderGroup(
  BuildContext context,
  SettingsValues values,
  String? parent,
) {
  // direct child settings
  final children = _sortSettings([
    for (final def in values.definitions)
      if (parent != null && settingIDParent(def.id) == parent) def,
  ], (d) => (d.id, SettingsTranslated.defName(d.id), d.order));

  // child groups
  final childGroups = _sortSettings([
    for (final group in values.groups)
      if (parent == null
          ? !group.id.contains(".")
          : settingIDParent(group.id) == parent)
        group,
  ], (g) => (g.id, SettingsTranslated.groupName(g.id), g.order));

  return [
    for (final def in children) ?_settingsTile(values, def),
    for (final group in childGroups) _GroupTile(values, group),
  ];
}

class const _GroupTile(final SettingsValues values, final SettingsGroup group)
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useSettings(["ui.transparency"]);
    final controller = useExpansibleController();
    final expanded = useState(true);

    final colors = context.colors;
    final icon = group.icon;

    // only show bg on first layer since its transparent
    final bg = group.id.split(".").length > 1
        ? null
        : colors.crust.withValues(alpha: SettingsDerived.transparency(0.7));
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
        SettingsTranslated.groupName(group.id),
        style: settingIDParent(group.id) == null
            ? const TextStyle(fontSize: 18, fontWeight: .w600)
            : null,
      ),
      shape: shape,
      collapsedShape: shape,
      // each child gets inset more
      tilePadding: .only(
        left: SettingsMenu.paddingFor(context, group.id),
        right: SettingsMenu.paddingFor(context),
      ),
      childrenPadding: const .only(bottom: 4),
      children: [..._renderGroup(context, values, group.id)],
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
