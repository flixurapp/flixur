import "dart:async";
import "dart:math";

import "package:flixur/hooks.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/ui/settings/menu.dart";
import "package:flixur/ui/settings/tiles/common.dart";
import "package:flixur/ui/settings/values.dart";
import "package:flixur/utils.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

/// Flattened bounds for an int/float setting.
typedef NumProps = ({
  double min,
  double max,
  double sliderMin,
  double sliderMax,
  double? step,
});

/// Converts a definition's props into [NumProps].
NumProps numProps(SettingsDefinition def) {
  final isInt = def.kind == .int_;
  final min = isInt ? (def.int_?.min ?? 0).toDouble() : def.float?.min ?? 0.0;
  // min+10 to get 0-10 on definitions with no bounds
  // but if we set a min and no max, max has to be higher than min
  final max = isInt
      ? (def.int_?.max ?? (min + 10)).toDouble()
      : def.float?.max ?? (min + 10);
  return (
    min: min,
    max: max,
    sliderMin: isInt
        ? (def.int_?.recommendedMin ?? min).toDouble()
        : (def.float?.recommendedMin ?? min),
    sliderMax: isInt
        ? (def.int_?.recommendedMax ?? max).toDouble()
        : (def.float?.recommendedMax ?? max),
    step: isInt ? def.int_?.step?.toDouble() ?? 1 : def.float?.step,
  );
}

/// An int/float setting.
class const SettingsTileNumber(
  final SettingsDefinition def,
  final SettingsValues values, {
  final bool isSearching = false,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isInt = def.kind == .int_;
    final props = numProps(def);

    final debouncer = useFlixurDebounced(flushOnDispose: true);
    final focus = useFocusNode();
    final controller = useTextEditingController(
      text: _format(values.getValue<num>(def.id), isInt),
    );

    /// local override so the slider and input follow eachother
    final override = useState<double?>(null);

    /// whether the inputted value is out of bounds
    final belowMin = useState(false);
    final aboveMax = useState(false);
    final invalid = belowMin.value || aboveMax.value;

    // keep in sync with setting
    final revision = useSettingsChanges(values, [def.id]);
    useEffect(() {
      override.value = null;
      final text = _format(values.getValue<num>(def.id), isInt);
      if (!focus.hasFocus && controller.text != text) controller.text = text;
      return null;
    }, [revision]);

    // revert invalid input when the field loses focus
    useEffect(() {
      void listener() {
        if (focus.hasFocus || !(belowMin.value || aboveMax.value)) return;
        belowMin.value = false;
        aboveMax.value = false;
        override.value = null;
        controller.text = _format(values.getValue<num>(def.id), isInt);
      }

      focus.addListener(listener);
      return () => focus.removeListener(listener);
    }, const []);

    /// Queue a setting value change.
    void write(double value) {
      final cleaned = _clean(value);
      debouncer.run(
        () => unawaited(
          values.set<num>(def.id, isInt ? cleaned.round() : cleaned),
        ),
      );
    }

    const prefixStyle = TextStyle(fontSize: 12, height: 1.2);
    final prefixIcon = Padding(
      padding: const .directional(start: 2, end: 4),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Text(
            "<${_format(props.max, isInt)}",
            style: prefixStyle.copyWith(
              color: aboveMax.value
                  ? context.colors.error
                  : context.colors.textMuted,
            ),
          ),
          Text(
            ">${_format(props.min, isInt)}",
            style: prefixStyle.copyWith(
              color: belowMin.value
                  ? context.colors.error
                  : context.colors.textMuted,
            ),
          ),
        ],
      ),
    );

    final input = FlixurInput(
      underlined: true,
      textField: (decoration) {
        final deco = decoration.copyWith(
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(),
        );
        final errorBorder = UnderlineInputBorder(
          borderSide: BorderSide(color: context.colors.error, width: 2),
        );

        return TextField(
          controller: controller,
          focusNode: focus,
          keyboardType: .numberWithOptions(
            decimal: !isInt,
            signed: props.min < 0,
          ),
          // red text/cursor while invalid
          // we are not using errorText because it overflows
          cursorColor: invalid ? context.colors.error : null,
          style: invalid ? TextStyle(color: context.colors.error) : null,
          decoration: invalid
              ? deco.copyWith(border: errorBorder, focusedBorder: errorBorder)
              : deco,
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(isInt ? r"^-?\d*" : r"^-?\d*\.?\d*"),
            ),
          ],
          onChanged: (text) {
            final value = double.tryParse(text);
            if (value == null) {
              belowMin.value = true;
              aboveMax.value = true;
              return;
            }
            belowMin.value = value < props.min;
            aboveMax.value = value > props.max;
            if (belowMin.value || aboveMax.value) return;
            override.value = value;
            write(value);
          },
        );
      },
    );

    final current = override.value ?? values.getValue<num>(def.id).toDouble();
    final slider = Slider(
      value: current.clamp(props.sliderMin, props.sliderMax),
      min: props.sliderMin,
      max: props.sliderMax,
      divisions: props.step != null && props.sliderMax > props.sliderMin
          ? ((props.sliderMax - props.sliderMin) / props.step!).round()
          : null,
      label: _format(current, isInt),
      onChanged: (value) {
        override.value = value;
        // drop focus if we move the slider
        if (focus.hasFocus) focus.unfocus();
        controller.text = _format(value, isInt);
        write(value);
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) => SettingsTileShell(
        def,
        values,
        isSearching: isSearching,
        vertical: context.isLandscape
            ? SizedBox(
                width: max(
                  200,
                  (constraints.maxWidth * 0.25) -
                      SettingsMenu.paddingFor(
                        context,
                        isSearching ? null : def.id,
                      ),
                ),
                child: input,
              )
            : input,
        content: LayoutBuilder(
          builder: (context, constraints) => context.isLandscape
              ? SizedBox(width: min(600, constraints.maxWidth), child: slider)
              : slider,
        ),
      ),
    );
  }
}

/// Clean up floating point issues.
/// We also don't really need precision higher than 5.
double _clean(double value) => double.parse(value.toStringAsFixed(5));

/// Formats the given number as a string.
String _format(num value, bool isInt) =>
    isInt ? value.toInt().toString() : _clean(value.toDouble()).toString();
