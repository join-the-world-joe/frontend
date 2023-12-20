import 'package:flutter_framework/common/translator/chinese.dart';
import 'package:flutter_framework/common/translator/english.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/plugin/crypto/rsa.dart';
import 'package:flutter_framework/plugin/crypto/aes.dart';

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
