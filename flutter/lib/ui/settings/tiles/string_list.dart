import "dart:async";

import "package:flixur/settings.dart";
import "package:flixur/ui/dropdowns.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/ui/settings/tiles/common.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flixur/utils.dart";
import "package:flutter/foundation.dart";
import "package:flutter/rendering.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// A stringlist setting.
class const SettingsTileStringList(
  final SettingsDefinition def,
  final SettingsValues values, {
  final bool isSearching = false,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final props = def.stringList;
    final allowDuplicates = props?.allowDuplicates ?? false;
    final maxItems = props?.maxItems;
    final choices = props?.choices?.toList() ?? const <SettingsChoice>[];

    final expanded = useState(false);
    final items = useState<List<String>>(values.getValue<List<String>>(def.id));
    final duplicateError = useState(false);
    final dragging = useValueNotifier<int?>(null);

    final addController = useTextEditingController();
    useValueChanged(Settings.activeProfileID, (_, _) => addController.clear());

    // for the delayed drag setting
    useListenable(RendererBinding.instance.mouseTracker);

    // keep in sync with setting
    // listen to all values here since we need profile changes for resets
    final revision = useSettingsChanges(values);
    useEffect(() {
      final value = values.getValue<List<String>>(def.id);
      if (!listEquals(items.value, value)) items.value = value;
      return null;
    }, [revision]);

    final full = maxItems != null && items.value.length >= maxItems;

    /// Updates the local list and persists.
    void write(List<String> value) {
      items.value = value;
      unawaited(values.set<List<String>>(def.id, value));
    }

    /// Tries to add [value], clearing controllers on success.
    void addItem(String value) {
      final text = value.trim();
      if (text.isEmpty || full) return;
      if (!allowDuplicates && items.value.contains(text)) return;
      write([...items.value, text]);

      duplicateError.value = false;
      addController.clear();
    }

    // spec choice map
    final specOf = {for (final choice in choices) choice.value: choice};
    final list = ReorderableListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      padding: .zero,
      onReorderItem: (oldIndex, newIndex) {
        // onReorderItem already adjusts newIndex for the removed old item
        final value = items.value[oldIndex];
        write(
          [...items.value]
            ..removeAt(oldIndex)
            ..insert(newIndex, value),
        );
      },
      onReorderStart: (i) => dragging.value = i,
      onReorderEnd: (i) => dragging.value = null,
      proxyDecorator: (child, index, animation) => child,
      children: [
        for (final (index, value) in items.value.indexed)
          _ItemRow(
            def.id,
            specOf[value],
            value,
            index,
            isServer: values.isServer,
            key: ValueKey("$index:$value"),
            dragging: dragging,
            onRemove: () => write([...items.value]..removeAt(index)),
          ),
      ],
    );

    // only unselected choices unless duplicates are allowed
    final availableChoices = [
      for (final choice in choices)
        if (allowDuplicates || !items.value.contains(choice.value)) choice,
    ];

    // dropdown of choice hints
    final addDropdown = FlixurDropdownMenu<String>(
      controller: addController,
      hintText: t.btn_add,
      requestFocusOnTap: false,
      dropdownMenuEntries: [
        for (final choice in availableChoices)
          DropdownMenuEntry(
            value: choice.value,
            label: SettingsTranslated.choiceName(
              def.id,
              choice.value,
              isServer: values.isServer,
            ),
            leadingIcon: (choice.icon?.isNotEmpty ?? false)
                ? Iconify(choice.icon!, size: 18)
                : null,
          ),
      ],
      onSelected: (value) {
        if (value != null) addItem(value);
      },
    );

    // free text field for lists with no choices
    final addField = FlixurInput(
      textField: (decoration) {
        final errorBorder = decoration.border?.copyWith(
          borderSide: BorderSide(color: context.colors.error, width: 2),
        );
        return TextField(
          controller: addController,
          // red text/cursor while invalid
          cursorColor: duplicateError.value ? context.colors.error : null,
          style: duplicateError.value
              ? TextStyle(color: context.colors.error)
              : null,
          decoration: duplicateError.value
              ? decoration.copyWith(
                  border: errorBorder,
                  focusedBorder: errorBorder,
                )
              : decoration.copyWith(
                  prefixIcon: IconButton(
                    onPressed: () => addItem(addController.text),
                    icon: const Iconify("plus"),
                    iconSize: 18,
                    tooltip: t.btn_add,
                    style: .new(iconColor: .all(context.colors.textMuted)),
                  ),
                ),
          onChanged: (text) => duplicateError.value =
              !allowDuplicates && items.value.contains(text.trim()),
          onSubmitted: addItem,
        );
      },
    );

    final addControl = full
        ? null
        : choices.isNotEmpty
        ? addDropdown
        : addField;
    final editor = Column(
      spacing: 10,
      crossAxisAlignment: .start,
      children: [if (items.value.isNotEmpty) list, ?addControl],
    );

    final selectionText =
        "${items.value.length}${maxItems == null ? "" : "/$maxItems"}";
    return SettingsTileShell(
      def,
      values,
      isSearching: isSearching,
      content: Column(
        spacing: 8,
        crossAxisAlignment: .start,
        children: [
          Text(
            items.value.length == 1 && maxItems == null
                ? t.items_selected.single(n: selectionText)
                : t.items_selected.many(n: selectionText),
            style: TextStyle(fontSize: 12, color: context.colors.textMuted),
          ),
          if (expanded.value) editor,
        ],
      ),
      trailing: IconButton(
        onPressed: () => expanded.value = !expanded.value,
        icon: Iconify(expanded.value ? "check" : "pencil-simple", size: 24),
        tooltip: expanded.value ? t.btn_save : t.btn_edit,
      ),
    );
  }
}

/// A single reorderable list item row.
class const _ItemRow(
  final String def,
  final SettingsChoice? spec,
  final String value,
  final int index, {
  required final bool isServer,
  required final ValueNotifier<int?> dragging,
  required final VoidCallback onRemove,
  super.key,
}) extends StatelessWidget {
  static const _size = 20.0;

  @override
  Widget build(BuildContext context) {
    final choice = spec;
    final label = choice == null
        ? value
        : SettingsTranslated.choiceName(def, choice.value, isServer: isServer);
    final icon = choice?.icon;

    final row = ValueListenableBuilder(
      valueListenable: dragging,
      // change mouse cursor based on dragging state
      builder: (context, dragging, _) => InkWell(
        mouseCursor: dragging != null
            ? SystemMouseCursors.grabbing
            : SystemMouseCursors.grab,
        child: Container(
          margin: const .symmetric(vertical: 2),
          padding: const .symmetric(
            horizontal: _size / 1.5,
            vertical: _size / 4,
          ),
          decoration: BoxDecoration(
            color: context.colors.crust.withValues(
              alpha: dragging == index ? 1 : SettingsDerived.transparency(0.35),
            ),
            borderRadius: const BorderRadius.all(.circular(_size / 2)),
          ),
          child: Row(
            spacing: _size / 3,
            children: [
              Iconify(
                "dots-six",
                size: _size + 2,
                color: context.colors.textMuted,
              ),
              if (icon != null && icon.isNotEmpty)
                Iconify(icon, size: _size + 2),
              Expanded(
                child: Text(label, style: const .new(fontSize: _size)),
              ),
              IconButton(
                onPressed: onRemove,
                iconSize: _size + 2,
                icon: const Iconify("x"),
                tooltip: t.btn_remove,
                constraints: .tight(const .square(_size * 1.75)),
                style: .new(iconColor: .all(context.colors.textMuted)),
              ),
            ],
          ),
        ),
      ),
    );

    // if a mouse is connected then we dont have to delay the dragging gesture
    return RendererBinding.instance.mouseTracker.mouseIsConnected
        ? ReorderableDragStartListener(index: index, child: row)
        : ReorderableDelayedDragStartListener(index: index, child: row);
  }
}
