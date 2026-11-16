// Most-used color extraction algorithm.
// Loosely based on https://github.com/darosh/colorgram-js
import "dart:math" as math;
import "dart:ui" as ui;

import "package:adaptive_palette/adaptive_palette.dart"
    show loadImageFromProvider;
import "package:material_ui/material_ui.dart";

/// Width used when calculating image colors.
const _calcWidth = 400;

/// Memoized results keyed by `(provider, count)`.
final _cache = <(ImageProvider, int), List<Color>>{};

/// Returns the top [count] dominant colors, most frequent first.
///
/// Colors are quantized into RGB buckets and ranked purely by frequency.
/// May return fewer than [count] colors on unusual images.
Future<List<Color>> extractColorgramColors(
  ImageProvider provider, {
  required int count,
}) async {
  final key = (provider, count);
  final cached = _cache[key];
  if (cached != null) return cached;

  final image = await loadImageFromProvider(provider);
  final colors = await _extractFromImage(image, count: count);
  return _cache[key] = colors;
}

Future<List<Color>> _extractFromImage(
  ui.Image image, {
  required int count,
}) async {
  final bytes = await image.toByteData();
  if (bytes == null) return const [];

  final pixels = bytes.buffer.asUint8List();
  final stride = math.max(1, image.width ~/ _calcWidth);

  // Quantize to 3 bits per channel (8x8x8 = 512 buckets), accumulating
  // frequency and color sums per bucket.
  final counts = <int, int>{};
  final sumR = <int, int>{};
  final sumG = <int, int>{};
  final sumB = <int, int>{};

  for (var y = 0; y < image.height; y += stride) {
    for (var x = 0; x < image.width; x += stride) {
      final i = (y * image.width + x) * 4;
      if (i + 3 >= pixels.length) continue;

      // Sources are opaque artwork; skip near-transparent pixels.
      if (pixels[i + 3] < 128) continue;

      final key =
          (pixels[i] >> 5) << 10 |
          (pixels[i + 1] >> 5) << 5 |
          (pixels[i + 2] >> 5);
      counts[key] = (counts[key] ?? 0) + 1;
      sumR[key] = (sumR[key] ?? 0) + pixels[i];
      sumG[key] = (sumG[key] ?? 0) + pixels[i + 1];
      sumB[key] = (sumB[key] ?? 0) + pixels[i + 2];
    }
  }

  if (counts.isEmpty) return const [];

  final keys = counts.keys.toList()
    ..sort((a, b) => counts[b]!.compareTo(counts[a]!));

  return [
    for (final key in keys.take(count))
      Color.fromARGB(
        255,
        (sumR[key]! ~/ counts[key]!).clamp(0, 255),
        (sumG[key]! ~/ counts[key]!).clamp(0, 255),
        (sumB[key]! ~/ counts[key]!).clamp(0, 255),
      ),
  ];
}
