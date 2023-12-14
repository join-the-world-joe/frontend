import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/backend_gateway.dart';
import 'package:flutter_framework/common/route/inform.dart';
import 'package:flutter_framework/common/route/major.dart';

class Route {
  static String getKey({required String major, required String minor}) {
    switch (major) {
      case Major.admin:
        return '${Major.getName(major: major)}.${Admin().getName(minor: minor)}';
      case Major.backendGateway:
        return '${Major.getName(major: major)}.${BackendGateway().getName(minor: minor)}';
      case Major.inform:
        return '${Major.getName(major: major)}.${Inform().getName(minor: minor)}';
      default:
        return 'unknown';
    }
  }
}
