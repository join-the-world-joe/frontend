import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class UpdateRecordOfGoodReq {
  final String _name;
  final int _productId;
  final int _buyingPrice;
  final int _status;
  final String _vendor;
  final String _contact;
  final String _description;

  UpdateRecordOfGoodReq(this._productId, this._name, this._buyingPrice, this._status, this._vendor, this._contact, this._description);

  Map<String, dynamic> toJson() => {
        'name': utf8.encode(_name),
        'product_id': _productId,
        'buying_price': _buyingPrice,
        'vendor': utf8.encode(_vendor),
        'status': _status,
        'contact': utf8.encode(_contact),
        'description': utf8.encode(_description),
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class UpdateRecordOfGoodRsp {
  late int code;

  UpdateRecordOfGoodRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void updateRecordOfGood({
  required String name,
  required int productId,
  required int buyingPrice,
  required int status,
  required String vendor,
  required String contact,
  required String description,
}) {
  PacketClient packet = PacketClient.create();
  UpdateRecordOfGoodReq req = UpdateRecordOfGoodReq(
    productId,
    name,
    buyingPrice,
    status,
    vendor,
    contact,
    description,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.updateRecordOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
