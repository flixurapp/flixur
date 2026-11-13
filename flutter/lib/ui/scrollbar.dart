import "dart:ui" show clampDouble, lerpDouble;

import "package:flutter/gestures.dart";
import "package:material_ui/material_ui.dart";

/// App-wide scrollbar behavior.
class const AppScrollBehavior() extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return AppScrollbar(controller: details.controller, child: child);
  }
}

/// Custom app scrollbar.
class const AppScrollbar({required super.child, super.controller, super.key})
    extends RawScrollbar {
  @override
  RawScrollbarState<AppScrollbar> createState() => _AppScrollbarState();
}

class _AppScrollbarState extends RawScrollbarState<AppScrollbar> {
  Set<WidgetState> get _states => <WidgetState>{
    if (_dragIsActive) WidgetState.dragged,
    if (_hoverIsActive) WidgetState.hovered,
  };
  Offset? _lastTrackDragPosition;

  /// Cached [ScrollbarTheme] applied to the bar.
  late ScrollbarThemeData _scrollbarTheme;
  @override
  bool get showScrollbar =>
      widget.thumbVisibility ??
      _scrollbarTheme.thumbVisibility?.resolve(_states) ??
      false;
  @override
  bool get enableGestures =>
      widget.interactive ?? _scrollbarTheme.interactive ?? true;
  @override
  void didChangeDependencies() {
    _scrollbarTheme = ScrollbarTheme.of(context);
    super.didChangeDependencies();
  }

  ScrollController? get _effectiveController =>
      widget.controller ?? PrimaryScrollController.maybeOf(context);

  @override
  void updateScrollbarPainter() {
    super.updateScrollbarPainter();
    // use theme values to update painter
    scrollbarPainter
      ..color =
          widget.thumbColor ??
          _scrollbarTheme.thumbColor?.resolve(_states) ??
          scrollbarPainter.color
      ..thickness =
          widget.thickness ??
          _scrollbarTheme.thickness?.resolve(_states) ??
          scrollbarPainter.thickness
      ..radius = widget.radius ?? _scrollbarTheme.radius
      ..minLength =
          _scrollbarTheme.minThumbLength ?? scrollbarPainter.minLength;
  }

  @override
  Widget build(BuildContext context) {
    // adds out own drag gesture to the scrollbar track
    void init(DragGestureRecognizer instance) {
      instance
        ..gestureSettings = const DeviceGestureSettings(touchSlop: 0)
        ..dragStartBehavior = .down
        ..onStart = _handleTrackDragStart
        ..onUpdate = _handleTrackDragUpdate
        ..onEnd = _handleTrackDragEnd
        ..onCancel = _handleTrackDragCancel;
    }

    final gestures = <Type, GestureRecognizerFactory>{};
    switch (getScrollbarDirection()) {
      case Axis.horizontal:
        gestures[_HorizontalTrackDragRecognizer] =
            GestureRecognizerFactoryWithHandlers<
              _HorizontalTrackDragRecognizer
            >(() => _HorizontalTrackDragRecognizer(state: this), init);
      case Axis.vertical || null:
        gestures[_VerticalTrackDragRecognizer] =
            GestureRecognizerFactoryWithHandlers<_VerticalTrackDragRecognizer>(
              () => _VerticalTrackDragRecognizer(state: this),
              init,
            );
    }
    return RawGestureDetector(gestures: gestures, child: super.build(context));
  }

  bool _dragIsActive = false;

  @override
  void handleThumbPressStart(Offset localPosition) {
    super.handleThumbPressStart(localPosition);
    setState(() => _dragIsActive = true);
  }

  @override
  void handleThumbPressEnd(Offset localPosition, Velocity velocity) {
    super.handleThumbPressEnd(localPosition, velocity);
    setState(() => _dragIsActive = false);
  }

  bool _hoverIsActive = false;

  @override
  void handleHover(PointerHoverEvent event) {
    super.handleHover(event);
    // only do hover state if hovering over the thumb
    if (isPointerOverThumb(event.position, event.kind)) {
      if (!_hoverIsActive) setState(() => _hoverIsActive = true);
    } else if (_hoverIsActive) {
      setState(() => _hoverIsActive = false);
    }
  }

  @override
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);
    if (_hoverIsActive) setState(() => _hoverIsActive = false);
  }

  @override
  // completely overrides stcok scrollbar to add custom tap behavior
  // directly jumps to the tapped position on the scrollbar
  // ignore: must_call_super
  void handleTrackTapDown(TapDownDetails details) {
    final offset = _scrollOffsetForTrack(details.localPosition);
    if (offset == null) return;
    _effectiveController?.position.moveTo(
      offset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }

  /// Whether [event] is over top of the track.
  bool _isOverTrack(Axis axis, PointerEvent event) {
    if (!enableGestures || getScrollbarDirection() != axis) return false;
    final renderBox = context.findRenderObject();
    if (renderBox is! RenderBox) return false;
    final local = renderBox.globalToLocal(event.position);
    return (scrollbarPainter.hitTest(local) ?? false) &&
        !scrollbarPainter.hitTestOnlyThumbInteractive(local, event.kind);
  }

  /// The scroll offset matching a position within the scrollbar's bounds,
  /// or null when the scrollable can't be scrolled.
  double? _scrollOffsetForTrack(Offset trackPosition) {
    final controller = _effectiveController;
    if (controller == null || controller.positions.length != 1) return null;
    final position = controller.position;
    if (!position.physics.shouldAcceptUserOffset(position)) return null;

    final textDirection = Directionality.of(context);
    final padding = MediaQuery.paddingOf(context);
    final mainAxisMargin = _scrollbarTheme.mainAxisMargin ?? 0;
    final reversed = switch (position.axisDirection) {
      AxisDirection.up || AxisDirection.left => true,
      _ => false,
    };
    // the track is only offset by MediaQuery padding and the main-axis margins
    final traversableExtent =
        position.viewportDimension -
        switch (position.axis) {
          Axis.vertical => padding.vertical,
          Axis.horizontal => padding.horizontal,
        } -
        2 * mainAxisMargin;
    // top edge of the traversable part of the track
    final trackTop =
        switch (position.axis) {
          Axis.vertical => padding.top,
          Axis.horizontal => padding.left,
        } +
        mainAxisMargin;
    final tapMainAxis = switch (position.axis) {
      Axis.vertical => trackPosition.dy,
      Axis.horizontal =>
        textDirection == .ltr
            ? trackPosition.dx
            : position.viewportDimension - trackPosition.dx,
    };

    // the content at the tapped position becomes the top of the viewport
    final fraction = clampDouble(
      (tapMainAxis - trackTop) / traversableExtent,
      0,
      1,
    );
    return lerpDouble(
      position.minScrollExtent,
      position.maxScrollExtent,
      reversed ? 1 - fraction : fraction,
    );
  }

  void _handleTrackDragStart(DragStartDetails details) {
    _lastTrackDragPosition = details.localPosition;
    final offset = _scrollOffsetForTrack(details.localPosition);
    if (offset == null) return;

    final controller = _effectiveController!;
    // jump the thumb to the scroll position
    controller.position.jumpTo(offset);
    // then transfer the drag over to the stock thumb-dragger
    handleThumbPress();
    handleThumbPressStart(details.localPosition);
  }

  void _handleTrackDragUpdate(DragUpdateDetails details) {
    _lastTrackDragPosition = details.localPosition;
    handleThumbPressUpdate(details.localPosition);
  }

  void _handleTrackDragEnd(DragEndDetails details) {
    _lastTrackDragPosition = null;
    handleThumbPressEnd(details.localPosition, details.velocity);
  }

  void _handleTrackDragCancel() {
    handleThumbPressEnd(_lastTrackDragPosition ?? Offset.zero, Velocity.zero);
    _lastTrackDragPosition = null;
  }
}

/// Drag recognizer for the track.
class _VerticalTrackDragRecognizer({required final _AppScrollbarState _state})
    extends VerticalDragGestureRecognizer {
  this : super(debugOwner: _state);
  @override
  bool isPointerPanZoomAllowed(PointerPanZoomStartEvent event) => false;
  @override
  bool isPointerAllowed(PointerEvent event) {
    return _state._isOverTrack(Axis.vertical, event) &&
        super.isPointerAllowed(event);
  }
}

/// Horizontal version of [_VerticalTrackDragRecognizer].
class _HorizontalTrackDragRecognizer({required final _AppScrollbarState _state})
    extends HorizontalDragGestureRecognizer {
  this : super(debugOwner: _state);
  @override
  bool isPointerPanZoomAllowed(PointerPanZoomStartEvent event) => false;
  @override
  bool isPointerAllowed(PointerEvent event) {
    return _state._isOverTrack(Axis.horizontal, event) &&
        super.isPointerAllowed(event);
  }
}
