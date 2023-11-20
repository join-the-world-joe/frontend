import 'dart:math';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class CheckPermissionReq {
  final int _major;
  final int _minor;

  CheckPermissionReq(this._major, this._minor);

  Map<String, dynamic> toJson() => {
        'major': _major,
        'minor': _minor,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class CheckPermissionRsp {
  late int _code;
  late int _major;
  late int _minor;

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
    _code = json['code'] ?? -1;
    _major = json['major'] ?? 0;
    _minor = json['minor'] ?? 0;
  }
}

void checkPermission({
  required String major,
  required String minor,
}) {
  PacketClient packet = PacketClient.create();
  CheckPermissionReq req = CheckPermissionReq(int.parse(major), int.parse(minor));
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.checkPermissionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
