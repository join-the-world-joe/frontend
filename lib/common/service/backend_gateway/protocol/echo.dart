import 'dart:typed_data';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class PingReq {
  String _message = '';

  PingReq.construct({
    required String message,
  }) {
    _message = message;
  }

  Map<String, dynamic> toJson() {
    return {
      'message': _message,
    };
  }
}

class PongRsp {
  int _code = -1;
  String _message = '';

  int getCode() {
    return _code;
  }

  String getMessage() {
    return _message;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  PongRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('message')) {
      _message = json['message'];
    }
  }
}
