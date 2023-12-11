import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_framework/utils/convert.dart';

class CheckPermissionReq {
  int _major = -1;
  int _minor = -1;

  CheckPermissionReq.construct({
    required int major,
    required int minor,
  }) {
    _major = major;
    _minor = minor;
  }

  Map<String, dynamic> toJson() {
    return {
      'major': _major,
      'minor': _minor,
    };
  }
}

class CheckPermissionRsp {
  int _code = -1;
  int _major = -1;
  int _minor = -1;

  int getCode() {
    return _code;
  }

  int getMajor() {
    return _major;
  }

  int getMinor() {
    return _minor;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  CheckPermissionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('major')) {
        _major = body['major'];
      }
      if (body.containsKey('minor')) {
        _minor = body['minor'];
      }
    }
  }
}
