import 'package:flutter/material.dart';
import '../Extensions/int_extensions.dart';

import 'Colors.dart';
import 'Constants.dart';

/// Default box shadow
List<BoxShadow> defaultBoxShadow({
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
}) {
  return [
    BoxShadow(
      color: shadowColor ?? shadowColorGlobal,
      blurRadius: blurRadius ?? defaultBlurRadius,
      spreadRadius: spreadRadius ?? defaultSpreadRadius,
      offset: offset,
    )
  ];
}

BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? defaultRadius));
}

enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

extension GetDurationUtils on Duration {
  ///  await Duration(seconds: 1).delay();
  Future<void> get delay => Future.delayed(this);
}

Route<T> buildPageRoute<T>(Widget child, PageRouteAnimation? pageRouteAnimation, Duration? duration) {
  if (pageRouteAnimation != null) {
    if (pageRouteAnimation == PageRouteAnimation.Fade) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: duration ?? 1000.milliseconds,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => RotationTransition(child: child, turns: ReverseAnimation(anim)),
        transitionDuration: duration ?? 700.milliseconds,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => ScaleTransition(child: child, scale: anim),
        transitionDuration: duration ?? 700.milliseconds,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          child: child,
          position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(anim),
        ),
        transitionDuration: duration ?? 500.milliseconds,
      );
    } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          child: child,
          position: Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(anim),
        ),
        transitionDuration: duration ?? 500.milliseconds,
      );
    }
  }
  return MaterialPageRoute<T>(builder: (_) => child);
}

/// returns Radius
BorderRadius radiusWidget([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? defaultRadius));
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? defaultRadius);
}

Decoration boxDecorationDefaultWidget({
  BorderRadiusGeometry? borderRadius,
  Color? color,
  Gradient? gradient,
  BoxBorder? border,
  BoxShape? shape,
  BlendMode? backgroundBlendMode,
  List<BoxShadow>? boxShadow,
  DecorationImage? image,
}) {
  return BoxDecoration(
    borderRadius: (shape != null && shape == BoxShape.circle) ? null : (borderRadius ?? radiusWidget()),
    boxShadow: boxShadow ?? defaultBoxShadow(),
    color: color ?? Colors.white,
    gradient: gradient,
    border: border,
    shape: shape ?? BoxShape.rectangle,
    backgroundBlendMode: backgroundBlendMode,
    image: image,
  );
}

/// rounded box decoration
Decoration boxDecorationWithRoundedCornersWidget({
  Color backgroundColor = whiteColor,
  BorderRadius? borderRadius,
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
}) {
  return BoxDecoration(
    color: backgroundColor,
    borderRadius: boxShape == BoxShape.circle ? null : (borderRadius ?? radiusWidget()),
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    image: decorationImage,
    shape: boxShape,
  );
}

/// box decoration with shadow
Decoration boxDecorationWithShadowWidget({
  Color backgroundColor = whiteColor,
  Color? shadowColor,
  double? blurRadius,
  double? spreadRadius,
  Offset offset = const Offset(0.0, 0.0),
  LinearGradient? gradient,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,
  DecorationImage? decorationImage,
  BoxShape boxShape = BoxShape.rectangle,
  BorderRadius? borderRadius,
}) {
  return BoxDecoration(
    boxShadow: boxShadow ??
        defaultBoxShadow(
          shadowColor: shadowColor,
          blurRadius: blurRadius,
          spreadRadius: spreadRadius,
          offset: offset,
        ),
    color: backgroundColor,
    gradient: gradient,
    border: border,
    image: decorationImage,
    shape: boxShape,
    borderRadius: borderRadius,
  );
}

/// rounded box decoration with shadow
Decoration boxDecorationRoundedWithShadowWidget(
    int radiusAll, {
      Color backgroundColor = whiteColor,
      Color? shadowColor,
      double? blurRadius,
      double? spreadRadius,
      Offset offset = const Offset(0.0, 0.0),
      LinearGradient? gradient,
    }) {
  return BoxDecoration(
    boxShadow: defaultBoxShadow(
      shadowColor: shadowColor ?? shadowColorGlobal,
      blurRadius: blurRadius ?? defaultBlurRadius,
      spreadRadius: spreadRadius ?? defaultSpreadRadius,
      offset: offset,
    ),
    color: backgroundColor,
    gradient: gradient,
    borderRadius: radiusWidget(radiusAll.toDouble()),
  );
}

ShapeBorder dialogShape([double? borderRadius]) {
  return RoundedRectangleBorder(
    borderRadius: radius(borderRadius ?? defaultRadius),
  );
}
