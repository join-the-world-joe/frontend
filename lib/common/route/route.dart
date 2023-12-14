import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';

class Route {
  static String getKey({required String major, required String minor}) {
    switch (major) {
      case Major.admin:
        return '${Major.getName(major: major)}.${Admin().getName(minor: minor)}';
      default:
        return 'unknown';
    }
  }
}
