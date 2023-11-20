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

void notificationHandler(Map<String, dynamic> body) {
  print('notificationHandler');
  try {
    Notification notify = Notification.fromJson(body);
    if (event.containsKey(notify.event)) {
      Cache.setUserId(0);
      Cache.setMemberId('');
      Cache.setMenuList(MenuList([], 0));
    }
  } catch (e) {
    print("notificationHandler failure, $e");
    return;
  }
}
