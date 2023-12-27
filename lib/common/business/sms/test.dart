

import 'dart:convert';

import 'package:flutter_framework/common/protocol/admin/sign_in.dart';

void main() {
  var source = '''
  {"header":{"major":"4","minor":"2"},"body":{"code":0}}
  ''';
  var body = jsonDecode(source);
  var rsp = SignInRsp.fromJson(body);
  print(rsp.getCode());
}