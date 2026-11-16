import "package:flixur/hooks.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/background/algorithms.dart";
import "package:flixur/ui/theme.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";

/// Source for the ambient background.
sealed class BackgroundSource();

/// Background derived from an artwork image.
class BackgroundSourceImage(final String url) extends BackgroundSource;

abstract class BackgroundState {
  /// The main background source, shown with no overrides.
  static final _source = ValueNotifier<BackgroundSource?>(null);

  /// Overrides that pages can push to.
  static final _overrides = <String, BackgroundSource>{};

  /// Bumped on changes to signal rebuilds.
  static final revision = ValueNotifier<int>(0);

  /// Sets the main source. Null to remove.
  static void setSource(BackgroundSource? source) {
    if (_source.value == source) return;
    _source.value = source;
    revision.value++;
  }

  /// Pushes a source override. This one becomes shown.
  static void pushOverride(String key, BackgroundSource source) {
    _overrides[key] = source;
    revision.value++;
  }

  /// Removes a source override.
  static void removeOverride(String key) {
    if (_overrides.remove(key) == null) return;
    revision.value++;
  }

  /// The currently active source, if any.
  static BackgroundSource? source() =>
      _overrides.values.isEmpty ? _source.value : _overrides.values.last;
}

/// The root background painter layer.
class const BackgroundPainter({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useListenable(BackgroundState.revision);
    useSettings(["ui.background.algorithm"]);

    final source = BackgroundState.source();
    final algorithm = BackgroundAlgorithm.fromSetting(
      Settings.getValue<String>("ui.background.algorithm"),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: KeyedSubtree(
        // key based on algo and source presence
        key: ValueKey<(BackgroundAlgorithm, bool)>((algorithm, source == null)),
        child: switch (source) {
          null => const _DefaultGradient(),
          BackgroundSourceImage(:final url) => algorithm.build(
            NetworkImage(url),
          ),
        },
      ),
    );
  }
}

/// Slight theme-colored gradient as the default background.
class const _DefaultGradient() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final base = context.colors.base;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topLeft,
            end: .bottomRight,
            colors: [
              Color.lerp(base, Colors.white, 0.03)!,
              base,
              Color.lerp(base, Colors.black, 0.05)!,
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
      ),
    );
  }
}
