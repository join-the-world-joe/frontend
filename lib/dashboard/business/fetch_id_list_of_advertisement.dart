import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchIdListOfAdvertisementReq {
  final int _behavior;
  final String _advertisementName;

  FetchIdListOfAdvertisementReq(this._behavior, this._advertisementName);

  Map<String, dynamic> toJson() => {
        'behavior': _behavior,
        'advertisement_name': utf8.encode(_advertisementName),
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchIdListOfAdvertisementRsp {
  int _code = -1;
  List<int> _idList = [];

  int getCode() {
    return _code;
  }

  List<int> getIdList() {
    return _idList;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  FetchIdListOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null) {
      _code = json['code'] ?? -1;
    }
    if (json.containsKey('body')) {
      var body = json['body'];
      if (body['id_list_of_advertisement'] != null) {
        _idList = List<int>.from(body['id_list_of_advertisement'] as List);
      }
    }
  }
}

void fetchIdListOfAdvertisement({
  required int behavior,
  required String advertisementName,
}) {
  PacketClient packet = PacketClient.create();
  FetchIdListOfAdvertisementReq req = FetchIdListOfAdvertisementReq(behavior, advertisementName);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchIdListOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
