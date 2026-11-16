import "package:collection/collection.dart";
import "package:flixur/ui/background/gradient/gradient.dart" show paletteSize;
import "package:material_ui/material_ui.dart";

/// Hue must be this far to be considered distinct.
const _hueDistanceReq = 30.0;

/// RGB summed channel distance required.
const rgbDistanceReq = 144;

/// Strength of the relative lightness shift (0 = none / 1 = full).
const _brightnessStrength = 0.5;

/// Hue distance in degrees.
double _hueDistance(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

/// Summed per-channel RGB distance.
double rgbDistance(Color a, Color b) =>
    ((a.r - b.r).abs() + (a.g - b.g).abs() + (a.b - b.b).abs()) * 255;

/// Determines if [candidate] is distinct from every [picked] color.
bool _isDistinct(Color candidate, List<Color> picked) {
  final candidateHue = HSLColor.fromColor(candidate).hue;
  for (final pickedColor in picked) {
    final pickedHsl = HSLColor.fromColor(pickedColor);
    if (_hueDistance(candidateHue, pickedHsl.hue) < _hueDistanceReq &&
        rgbDistance(candidate, pickedColor) < rgbDistanceReq) {
      return false;
    }
  }
  return true;
}

/// Combines the 2 color pallettes.
List<Color> _combinePalettes(List<Color> colorgram, List<Color> vibrants) {
  final picked = <Color>[];

  void addDistinct(List<Color> colors) {
    for (final color in colors) {
      if (picked.length >= paletteSize) return;
      if (_isDistinct(color, picked)) picked.add(color);
    }
  }

  // always pick the most common color
  if (colorgram.isNotEmpty) picked.add(colorgram.first);
  // dedupe the rest of the common colors
  addDistinct(colorgram.skip(1).toList());
  // backfill with vibrant colors
  addDistinct(vibrants);

  return picked;
}

/// Shifts every color's lightness toward the palette's own average luminance.
/// This preserves relative contrast between colors.
List<Color> _shiftBrightness(List<Color> colors) {
  if (colors.isEmpty) return colors;

  final target = colors
      .map((color) => HSLColor.fromColor(color).lightness)
      .average
      // clamp the target lightness to between these two
      .clamp(0.3, 0.55);

  return [
    for (final color in colors)
      () {
        final hsl = HSLColor.fromColor(color);
        return hsl
            .withLightness(
              (hsl.lightness + (target - hsl.lightness) * _brightnessStrength)
                  .clamp(0.0, 1.0),
            )
            .toColor();
      }(),
  ];
}

List<Color> combinePalettes(List<List<Color>> palettes) =>
    _shiftBrightness(_combinePalettes(palettes[0], palettes[1]));
