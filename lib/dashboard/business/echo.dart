import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class PingReq {
  final String _message;

  PingReq(this._message);

  Map<String, dynamic> toJson() => {
        'message': _message,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class PongRsp {
  late int _code;
  late String _message;

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
    _code = json['code'] ?? -1;
    _message = json['message'] ?? [''];
  }
}

void echo({
  required String message,
}) {
  PacketClient packet = PacketClient.create();
  PingReq req = PingReq(message);
  packet.getHeader().setMajor(Major.backendGateway);
  packet.getHeader().setMinor(Minor.backendGateway.pingReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
