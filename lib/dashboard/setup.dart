import 'package:flutter_framework/common/translator/chinese.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/app/config.dart';

void setup_() {
  Translator.setNative(Chinese.getName());
  try {
    Runtime.wsClient.setUrl(Config.url);
    Runtime.wsClient.connect();
    Runtime.wsClient.run();
    Runtime.periodic();
  } catch (e) {
    print('setup_ failure, err: $e');
  }
}
