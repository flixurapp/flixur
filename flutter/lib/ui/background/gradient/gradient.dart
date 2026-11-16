import "dart:async";
import "dart:math" as math;

import "package:flixur/ui/background/gradient/renderer.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";

/// Number of palette colors the background renders with.
const paletteSize = 4;

/// Pads [colors] to [count] by repeating the last one.
List<Color>? padPalette(List<Color> colors, int count) {
  if (colors.isEmpty) return null;
  while (colors.length < count) {
    colors.add(colors.last);
  }
  return colors;
}

/// Extractors can return fewer than [paletteSize] colors, it'll be padded.
/// The returned list must be growable.
class const GradientBackground(
  final ImageProvider provider,
  final Future<List<Color>> Function(ImageProvider provider) extractor, {
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final palette = useState<List<Color>?>(null);
    final fallbackPalette = List.generate(4, (i) => context.colors.base);

    // reload palette when the provider changes
    useEffect(() {
      Future<void> load() async {
        final result =
            padPalette(await extractor(provider), paletteSize) ??
            fallbackPalette;
        if (context.mounted) palette.value = result;
      }

      unawaited(load());
      return null;
    }, [provider]);

    return TweenAnimationBuilder<List<Color>>(
      tween: _ColorListTween(end: palette.value ?? fallbackPalette),
      //TODO:setting
      duration: const Duration(milliseconds: 500),
      //TODO: figure out which function
      curve: Curves.easeInOut,
      builder: (context, colors, _) => GradientRenderer(colors: colors),
    );
  }
}

/// Tweens between two color lists. Will pad the shorter list.
class _ColorListTween({required super.end}) extends Tween<List<Color>> {
  @override
  List<Color> lerp(double t) {
    final b = end!;
    final a = begin ?? b;
    if (t == 0 || identical(a, b)) return a;
    if (t == 1) return b;

    final length = math.max(a.length, b.length);
    return [
      for (var i = 0; i < length; i++)
        Color.lerp(
          a[i.clamp(0, a.length - 1)],
          b[i.clamp(0, b.length - 1)],
          t,
        )!,
    ];
  }
}
