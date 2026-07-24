import "package:flutter/material.dart";

extension AppResponsiveness on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Whether the current screen is a landscape layout.
  bool get isLandscape => screenSize.width > screenSize.height;

  bool withWidthUnder(double width) => screenSize.width < width;
  bool withHeightUnder(double height) => screenSize.height < height;
}
