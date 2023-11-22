import 'package:flutter_framework/common/translator/chinese.dart';
import 'package:flutter_framework/common/translator/english.dart';

class Translator {
  static String _native = '';

  static setNative(String language) {
    _native = language;
  }

  static String getNative() {
    return _native;
  }

  static String translate(String input) {
    if (_native == Chinese.getName()) {
      return Chinese.translate(input);
    } else if (_native == English.getName()) {
      return English.translate(input);
    } else {
      return 'Unknown native: $_native';
    }
  }
}
