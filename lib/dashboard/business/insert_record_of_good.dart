import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class InsertRecordOfGoodReq {
  final String _name;
  final String _vendor;
  final String _contact;
  final int _buyingPrice;
  final String _desc;
  final int _status;

  InsertRecordOfGoodReq(this._name, this._vendor, this._contact, this._buyingPrice, this._desc, this._status);

  Map<String, dynamic> toJson() => {
        'name': utf8.encode(_name),
        'vendor': utf8.encode(_vendor),
        'contact': utf8.encode(_contact),
        'buying_price': _buyingPrice,
        'description': _desc,
        'status': _status,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class InsertRecordOfGoodRsp {
  late int code;

  InsertRecordOfGoodRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void insertRecordOfGood({
  required String name,
  required String vendor,
  required String contact,
  required int status,
  required int buyingPrice,
  required String description,
}) {
  PacketClient packet = PacketClient.create();
  InsertRecordOfGoodReq req = InsertRecordOfGoodReq(
    name,
    vendor,
    contact,
    buyingPrice,
    description,
    status,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.insertRecordOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
