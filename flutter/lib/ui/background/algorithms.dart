import "package:adaptive_palette/adaptive_palette.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/background/colorgram.dart";
import "package:flixur/ui/background/combined.dart";
import "package:flixur/ui/background/gradient/gradient.dart";
import "package:material_ui/material_ui.dart";

/// Background color algorithms, names must match the setting.
enum BackgroundAlgorithm {
  /// Smoothie
  d,

  /// Ice Cube
  a,

  /// Soda
  b,

  /// Milk
  c;

  /// Resolves the algorithm for the background setting value.
  /// Falls back to [BackgroundAlgorithm.d].
  static BackgroundAlgorithm fromSetting(String value) =>
      values.where((algorithm) => algorithm.name == value).firstOrNull ?? d;

  /// Builds the background for an artwork [provider].
  Widget build(ImageProvider provider) => SettingsListen(
    const ["ui.background.brightness"],
    builder: (_) => switch (this) {
      // gradients
      b => GradientBackground(
        provider,
        (p) => FluidPaletteExtractor.extractColors(p, count: paletteSize),
      ),
      c => GradientBackground(
        provider,
        (p) => extractColorgramColors(p, count: paletteSize),
      ),
      d => GradientBackground(
        provider,
        (p) async => combinePalettes(
          await Future.wait([
            extractColorgramColors(p, count: paletteSize * 2),
            FluidPaletteExtractor.extractColors(p, count: paletteSize + 2),
          ]),
        ),
      ),

      // fluid
      a => ColorFiltered(
        colorFilter: ColorFilter.mode(
          // the math is like this so that brightness is affected on the lower
          // half of the range
          Colors.black.withValues(
            alpha:
                (1 - Settings.getValue<double>("ui.background.brightness") * 2)
                    .clamp(0, 1),
          ),
          .srcOver,
        ),
        child: FluidBackground(
          imageProvider: provider,
          // we supply our own darkening
          overlayDarken: 0,
          smoothTransitions: true,
          //TODO:setting
          transitionDuration: const .new(milliseconds: 500),
          child: const SizedBox.expand(),
        ),
      ),
    },
  );
}
