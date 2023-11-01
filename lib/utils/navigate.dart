import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Navigate {
  static void pop(BuildContext context) {
    // go back
    Navigator.pop(context);
  }

  static void push(BuildContext context, Widget widget) {
    // go forth
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void pushReplacement(BuildContext context, Widget widget) {
    // goto
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => widget),
    // );
    Future.microtask(
          () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => widget)),
    );
  }

  static void forth(BuildContext context, Widget widget) {
    // go forth
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => widget),
    );
  }

  static void to(BuildContext context, Widget widget) {
    Future.microtask(
      () => Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => widget)),
    );
  }
}
