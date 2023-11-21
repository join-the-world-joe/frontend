import 'dart:core';

import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';

// event:description
Map<String, String> event = {
  Language.eventForceOffline: 'Force previous session to go offline.',
};

class Notification {
  String event = '';
  String message = '';

  Notification.fromJson(Map<String, dynamic> json) {
    event = json['event'] ?? '';
    message = json['message'] ?? '';
  }
}
