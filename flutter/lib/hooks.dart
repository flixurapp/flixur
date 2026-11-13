import "package:flixur/settings.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";

/// Hook that creates a [Debounced] and disposes it when the widget unmounts.
Debounced useFlixurDebounced({
  Duration duration = Debounced.defaultDuration,
  bool flushOnDispose = false,
  List<Object?>? keys,
}) => use(_DebouncedHook(duration, flushOnDispose: flushOnDispose, keys: keys));

class const _DebouncedHook(
  final Duration duration, {
  final bool flushOnDispose = false,
  super.keys,
}) extends Hook<Debounced> {
  @override
  _DebouncedHookState createState() => _DebouncedHookState();
}

class _DebouncedHookState extends HookState<Debounced, _DebouncedHook> {
  late final debouncer = Debounced(
    duration: hook.duration,
    flushOnDispose: hook.flushOnDispose,
  );
  @override
  Debounced build(BuildContext context) => debouncer;
  @override
  void dispose() => debouncer.dispose();
}

/// Rebuilds the calling HookWidget when any of [ids] change.
/// An empty [ids] listens to all settings.
/// Returns the current revision for use with [useEffect].
int useSettings([List<String> ids = const []]) {
  final revision = useState(0);
  // key on the joined IDs instead of list object
  final key = ids.join(",");
  useEffect(() => Settings.watch(ids).listen((_) => revision.value++).cancel, [
    key,
  ]);
  return revision.value;
}
