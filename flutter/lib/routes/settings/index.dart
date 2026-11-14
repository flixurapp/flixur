import "package:flixur/hooks.dart";
import "package:flixur/routes/settings/header.dart";
import "package:flixur/routes/settings/tiles/bool.dart";
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

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        SettingsViewHeader((value) => searchTerm.value = value),
        Expanded(
          child: ListView(
            padding: const .symmetric(horizontal: 16, vertical: 12),
            children: [..._renderGroup(context, null, searchTerm.value)],
          ),
        ),
      ],
    );
  }
}

/// Render a group's settings, then its children.
List<Widget> _renderGroup(
  BuildContext context,
  String? parent,
  String searchTerm,
) {
  final query = searchTerm.toLowerCase().trim();

  // direct child settings
  final definitions = Settings.definitions ?? [];
  final children = _sortSettings([
    for (final def in definitions)
      if (parent != null &&
          settingIDParent(def.id) == parent &&
          _settingMatches(def, query))
        def,
  ], (d) => (d.id, settingName(d.id), d.order));

  // child groups
  final groups = Settings.groups ?? [];
  final childGroups = _sortSettings([
    for (final group in groups)
      if ((parent == null
              ? !group.id.contains(".")
              : settingIDParent(group.id) == parent) &&
          _groupHasVisibleChildren(group.id, query))
        group,
  ], (g) => (g.id, settingGroupName(g.id), g.order));

  return [
    for (final def in children)
      switch (def.kind) {
        .bool_ => SettingsTileBool(def),
        //.int_ => SettingsTileInt(def),
        //.float => SettingsTileFloat(def),
        .string => SettingsTileString(def),
        //.enum_ => SettingsTileEnum(def),
        //.stringlist => SettingsTileStringList(def),
        _ => const SizedBox.shrink(),
      },
    for (final group in childGroups) _GroupTile(group, searchTerm),
  ];
}

class const _GroupTile(final SettingsGroup group, final String searchTerm)
    extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useExpansibleController();
    final expanded = useState(true);

    // force categories to be expanded while searching
    useEffect(() {
      if (searchTerm.isNotEmpty && !controller.isExpanded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) controller.expand();
        });
      }
      return null;
    }, [searchTerm]);

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
      children: [..._renderGroup(context, group.id, searchTerm)],
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

/// Whether a setting definition matches the [query].
bool _settingMatches(SettingsDefinition def, String query) {
  // empty queries always match
  if (query.isEmpty) return true;
  return Settings.searchIndex
      .search(query)
      .where((result) => result.item.id == def.id)
      .isNotEmpty;
}

/// Whether a group has any child settings that match the [query].
bool _groupHasVisibleChildren(String groupId, String query) {
  final definitions = Settings.definitions ?? [];
  return definitions
      .where((def) => def.id.startsWith(groupId) && _settingMatches(def, query))
      .isNotEmpty;
}
