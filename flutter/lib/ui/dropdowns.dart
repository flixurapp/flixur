import "package:flixur/ui/icons.dart";
import "package:material_ui/material_ui.dart";

// passthru with icons set
class const FlixurDropdownMenu<T>({
  required super.dropdownMenuEntries,
  super.trailingIcon = const Iconify("caret-down"),
  super.selectedTrailingIcon = const Iconify("caret-up"),
  super.initialSelection,
  super.expandedInsets,
  super.inputDecorationTheme,
  super.onSelected,
  super.enabled,
  super.requestFocusOnTap,
  super.key,
}) extends DropdownMenu<T>;
