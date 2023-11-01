import 'package:flutter/material.dart';

class Spacing {
  static Widget addVerticalSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget addHorizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }
}
