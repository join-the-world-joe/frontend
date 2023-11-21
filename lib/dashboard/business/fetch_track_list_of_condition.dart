import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchTrackListOfConditionReq {
  final String _operator;
  final int _behavior;
  final int _begin;
  final int _end;
  final String _major;
  final String _minor;

  FetchTrackListOfConditionReq(this._behavior, this._operator, this._begin, this._end, this._major, this._minor);

  Map<String, dynamic> toJson() => {
        'operator': utf8.encode(_operator),
        'behavior': _behavior,
        'begin': _begin,
        'end': _end,
        'major': _major,
        'minor': _minor,
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
  required String operator,
  required int behavior,
  required int begin,
  required int end,
  required String major,
  required String minor,
}) {
  PacketClient packet = PacketClient.create();
  FetchTrackListOfConditionReq req = FetchTrackListOfConditionReq(behavior, operator, begin, end, major, minor);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchTrackListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
