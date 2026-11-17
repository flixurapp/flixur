import "package:adaptive_palette/adaptive_palette.dart";
import "package:flixur/ui/background/colorgram.dart";
import "package:flixur/ui/background/combined.dart";
import "package:flixur/ui/background/gradient/gradient.dart";
import "package:material_ui/material_ui.dart";

/// Background color algorithms, names must match the setting.
enum BackgroundAlgorithm {
  smoothie,
  water,
  milk,
  fizzy;

  /// Resolves the algorithm for the background setting value.
  /// Falls back to [BackgroundAlgorithm.smoothie].
  static BackgroundAlgorithm fromSetting(String value) =>
      values.where((algorithm) => algorithm.name == value).firstOrNull ??
      smoothie;

  /// Builds the background for an artwork [provider].
  Widget build(ImageProvider provider) => switch (this) {
    // gradients
    smoothie => GradientBackground(provider, extractSmoothieColors),
    milk => GradientBackground(provider, extractMilkColors),
    fizzy => GradientBackground(provider, extractFizzyColors),

    // fluid
    water => ColorFiltered(
      colorFilter: ColorFilter.mode(
        //TODO:setting
        Colors.black.withValues(alpha: 2 * 0.25),
        .srcOver,
      ),
      child: FluidBackground(
        imageProvider: provider,
        overlayDarken: 1,
        smoothTransitions: true,
        //TODO:setting
        //transitionDuration: .zero,
        child: const SizedBox.expand(),
      ),
    ),
  };
}

Future<List<Color>> extractSmoothieColors(ImageProvider provider) async =>
    combinePalettes(
      await Future.wait([
        extractColorgramColors(provider, count: paletteSize * 2),
        FluidPaletteExtractor.extractColors(provider, count: paletteSize + 2),
      ]),
    );

Future<List<Color>> extractMilkColors(ImageProvider provider) =>
    FluidPaletteExtractor.extractColors(provider, count: paletteSize);

Future<List<Color>> extractFizzyColors(ImageProvider provider) =>
    extractColorgramColors(provider, count: paletteSize);
