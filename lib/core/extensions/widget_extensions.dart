import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  // Padding
  Widget padding(EdgeInsetsGeometry padding) => Padding(
    padding: padding,
    child: this,
  );
  
  Widget paddingAll(double value) => Padding(
    padding: EdgeInsets.all(value),
    child: this,
  );
  
  Widget paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    ),
    child: this,
  );
  
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );
  
  Widget get paddingZero => this;
  
  // Alignment
  Widget center() => Center(child: this);
  
  Widget align(AlignmentGeometry alignment) => Align(
    alignment: alignment,
    child: this,
  );
  
  Widget get alignCenter => align(Alignment.center);
  Widget get alignTopLeft => align(Alignment.topLeft);
  Widget get alignTopCenter => align(Alignment.topCenter);
  Widget get alignTopRight => align(Alignment.topRight);
  Widget get alignCenterLeft => align(Alignment.centerLeft);
  Widget get alignCenterRight => align(Alignment.centerRight);
  Widget get alignBottomLeft => align(Alignment.bottomLeft);
  Widget get alignBottomCenter => align(Alignment.bottomCenter);
  Widget get alignBottomRight => align(Alignment.bottomRight);
  
  // Sizing
  Widget sized({double? width, double? height}) => SizedBox(
    width: width,
    height: height,
    child: this,
  );
  
  Widget sizedBox({double? width, double? height}) => sized(
    width: width,
    height: height,
  );
  
  Widget get expand => SizedBox.expand(child: this);
  
  Widget get shrink => SizedBox.shrink(child: this);
  
  Widget height(double height) => SizedBox(
    height: height,
    child: this,
  );
  
  Widget width(double width) => SizedBox(
    width: width,
    child: this,
  );
  
  Widget square(double size) => SizedBox(
    width: size,
    height: size,
    child: this,
  );
  
  // Constraints
  Widget constrained({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) => ConstrainedBox(
    constraints: BoxConstraints(
      minWidth: minWidth ?? 0.0,
      maxWidth: maxWidth ?? double.infinity,
      minHeight: minHeight ?? 0.0,
      maxHeight: maxHeight ?? double.infinity,
    ),
    child: this,
  );
  
  Widget maxWidth(double width) => constrained(maxWidth: width);
  Widget minWidth(double width) => constrained(minWidth: width);
  Widget maxHeight(double height) => constrained(maxHeight: height);
  Widget minHeight(double height) => constrained(minHeight: height);
  
  // Flex
  Widget expanded({int flex = 1}) => Expanded(
    flex: flex,
    child: this,
  );
  
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => Flexible(
    flex: flex,
    fit: fit,
    child: this,
  );
  
  // Decoration
  Widget decorated({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BoxShape shape = BoxShape.rectangle,
  }) => DecoratedBox(
    decoration: BoxDecoration(
      color: color,
      image: image,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      gradient: gradient,
      shape: shape,
    ),
    child: this,
  );
  
  Widget background(Color color) => decorated(color: color);
  
  Widget borderRadius(BorderRadiusGeometry radius) => ClipRRect(
    borderRadius: radius,
    child: this,
  );
  
  Widget circular([double radius = 12]) => borderRadius(
    BorderRadius.circular(radius),
  );
  
  Widget get circle => ClipOval(child: this);
  
  // Visibility
  Widget visible(bool visible, {Widget? replacement}) => Visibility(
    visible: visible,
    replacement: replacement ?? const SizedBox.shrink(),
    child: this,
  );
  
  Widget opacity(double opacity) => Opacity(
    opacity: opacity,
    child: this,
  );
  
  Widget get hide => const SizedBox.shrink();
  
  // Gestures
  Widget onTap(VoidCallback? onTap, {
    bool opaque = true,
    HitTestBehavior? behavior,
  }) => GestureDetector(
    onTap: onTap,
    behavior: behavior ?? (opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild),
    child: this,
  );
  
  Widget onDoubleTap(VoidCallback? onDoubleTap) => GestureDetector(
    onDoubleTap: onDoubleTap,
    child: this,
  );
  
  Widget onLongPress(VoidCallback? onLongPress) => GestureDetector(
    onLongPress: onLongPress,
    child: this,
  );
  
  // Scrolling
  Widget scrollable({
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
  }) => SingleChildScrollView(
    scrollDirection: scrollDirection,
    reverse: reverse,
    physics: physics,
    padding: padding,
    child: this,
  );
  
  // Material
  Widget material({
    MaterialType type = MaterialType.canvas,
    double elevation = 0,
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    BorderRadiusGeometry? borderRadius,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    Clip clipBehavior = Clip.none,
  }) => Material(
    type: type,
    elevation: elevation,
    color: color,
    shadowColor: shadowColor,
    surfaceTintColor: surfaceTintColor,
    borderRadius: borderRadius,
    shape: shape,
    borderOnForeground: borderOnForeground,
    clipBehavior: clipBehavior,
    child: this,
  );
  
  Widget inkWell({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
  }) => InkWell(
    onTap: onTap,
    onDoubleTap: onDoubleTap,
    onLongPress: onLongPress,
    borderRadius: borderRadius,
    splashColor: splashColor,
    highlightColor: highlightColor,
    child: this,
  );
  
  // Hero
  Widget hero(String tag) => Hero(
    tag: tag,
    child: this,
  );
  
  // Sliver
  Widget get sliver => SliverToBoxAdapter(child: this);
  
  // Safe Area
  Widget safeArea({
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
  }) => SafeArea(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    child: this,
  );
  
  // Animation
  Widget animatedSize({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) => AnimatedSize(
    duration: duration,
    curve: curve,
    child: this,
  );
  
  Widget animatedOpacity({
    required double opacity,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) => AnimatedOpacity(
    opacity: opacity,
    duration: duration,
    curve: curve,
    child: this,
  );
  
  Widget animatedContainer({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    double? width,
    double? height,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BoxDecoration? decoration,
  }) => AnimatedContainer(
    duration: duration,
    curve: curve,
    width: width,
    height: height,
    color: color,
    padding: padding,
    margin: margin,
    decoration: decoration,
    child: this,
  );
}