import 'dart:math';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

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

void checkPermission({
  required String major,
  required String minor,
}) {
  PacketClient packet = PacketClient.create();
  CheckPermissionReq req = CheckPermissionReq.construct(
    major: int.parse(major),
    minor: int.parse(minor),
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.checkPermissionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
