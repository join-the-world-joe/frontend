import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchTrackListOfConditionReq {
  final String _name;
  final int _behavior;
  final String _begin;
  final String _end;
  final String _permissionName;

  FetchTrackListOfConditionReq(this._behavior, this._name, this._permissionName, this._begin, this._end);

  Map<String, dynamic> toJson() => {
        'name': _name,
        'behavior': _behavior,
        'begin': _begin,
        'end': _end,
        'permission': _permissionName,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchTrackListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchTrackListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchTrackListOfCondition({
  required String name,
  required int behavior,
  required String begin,
  required String end,
  required String permission,
}) {
  PacketClient packet = PacketClient.create();
  FetchTrackListOfConditionReq req = FetchTrackListOfConditionReq(behavior, name, permission, begin, end);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchTrackListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
