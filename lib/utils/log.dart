import 'package:flutter_framework/common/route/route.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class Log {
  static void debug({
    required String major,
    required String minor,
    required String from, // the file or content
    required String caller, // the caller of debug
    required String message,
  }) {
    if (Runtime.debug) {
      var routingKey = Route.getKey(major: major, minor: minor);
      print('$from.$caller($routingKey:$major-$minor) ${message.isNotEmpty?', $message':''}');
    }
  }
}
