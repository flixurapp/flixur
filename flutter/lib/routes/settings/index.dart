import "package:flixur/routes/settings/header.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SettingsView({super.key}) extends StatefulWidget {
  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _searchTerm = "";

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ValueListenableBuilder(
      valueListenable: Settings.changeNotifier,
      builder: (context, _, _) => Column(
        crossAxisAlignment: .stretch,
        children: [
          SettingsViewHeader((value) => setState(() => _searchTerm = value)),
          Expanded(
            child: ListView(
              padding: const .symmetric(horizontal: 16, vertical: 12),
              children: [...renderGroup(context, null)],
            ),
          ),
        ],
      ),
    );
  }

  /// Render a group's settings, then its children.
  List<Widget> renderGroup(BuildContext context, String? parent) {
    // direct child settings
    final definitions = Settings.definitions ?? [];
    final children = _sortSettings([
      for (final def in definitions)
        if (parent != null && _groupParent(def.id) == parent) def,
    ], (d) => (d.id, settingName(d.id), d.order));

    // child groups
    final groups = Settings.groups ?? [];
    final childGroups = _sortSettings([
      for (final group in groups)
        if (parent == null
            ? !group.id.contains(".")
            : _groupParent(group.id) == parent)
          group,
    ], (g) => (g.id, settingGroupName(g.id), g.order));

    return [
      //  for (final def in children) _settingTile(context, def),
      for (final group in childGroups) _GroupTile(this, group),
    ];
  }
}

class const _GroupTile(
  final _SettingsViewState parent,
  final SettingsGroup group,
) extends StatefulWidget {
  @override
  State<_GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<_GroupTile> {
  // starts open, matching initiallyExpanded
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final group = widget.group;
    final icon = group.icon;

    final bg = colors.crust;
    final shape = _groupParent(group.id) == null
        ? const RoundedRectangleBorder(borderRadius: .all(.circular(8)))
        : const Border();

    return ExpansionTile(
      key: ValueKey(group.id),
      collapsedBackgroundColor: bg,
      backgroundColor: bg,
      initiallyExpanded: true,
      onExpansionChanged: (value) => setState(() => expanded = value),
      trailing: AnimatedRotation(
        turns: expanded ? 0 : 0.5,
        duration: const Duration(milliseconds: 200),
        child: const Iconify("caret-down", size: 24),
      ),
      leading: icon == null || icon.isEmpty ? null : Iconify(icon),
      title: Text(
        settingGroupName(group.id),
        style: _groupParent(group.id) == null
            ? const TextStyle(fontSize: 18, fontWeight: .w600)
            : null,
      ),
      shape: shape,
      collapsedShape: shape,
      // each child gets inset more
      tilePadding: .only(left: group.id.split(".").length * 16, right: 16),
      childrenPadding: const .only(bottom: 4),
      children: [...widget.parent.renderGroup(context, group.id)],
    );
  }
}

/// Returns the parent group of an ID. Null for toplevel groups.
String? _groupParent(String id) {
  final dot = id.lastIndexOf(".");
  return dot <= 0 ? null : id.substring(0, dot);
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
