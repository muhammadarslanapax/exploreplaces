import 'package:flutter/material.dart';

extension IntExtensions on int? {
  /// Validate given int is not null and returns given value if null.
  int validate({int value = 0}) {
    return this ?? value;
  }

  /// Leaves given height of space
  Widget get height => SizedBox(height: this?.toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: this?.toDouble());

// BorderRadius borderRadius([double? val]) => radius(val);

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: this.validate());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: this.validate());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: this.validate());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: this.validate());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: this.validate());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: this.validate());

  /// Returns Size
  Size get size => Size(this!.toDouble(), this!.toDouble());

  /// HTTP status code
  bool isSuccessful() => this! >= 200 && this! <= 206;

}
