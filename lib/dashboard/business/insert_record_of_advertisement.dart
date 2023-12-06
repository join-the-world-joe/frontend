import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class InsertRecordOfAdvertisementReq {
  final String _name;
  final String _title;
  final int _sellingPrice;
  final String _sellingPoint;
  final String _placeOfOrigin;
  final String _url;
  final int _stock;
  final int _productId;
  final int _status;
  final String _description;

  InsertRecordOfAdvertisementReq(
    this._name,
    this._title,
    this._sellingPrice,
    this._sellingPoint,
    this._placeOfOrigin,
    this._url,
    this._stock,
    this._productId,
    this._status,
    this._description,
  );

  Map<String, dynamic> toJson() => {
        'name': utf8.encode(_name),
        'title': utf8.encode(_title),
        'selling_point': utf8.encode(_sellingPoint),
        'selling_price': _sellingPrice,
        'description': utf8.encode(_description),
        'status': _status,
        "url": utf8.encode(_url),
        "product_id": _productId,
        "stock": _stock,
        "place_of_origin": utf8.encode(_placeOfOrigin),
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class InsertRecordOfAdvertisementRsp {
  late int code;

  InsertRecordOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void insertRecordOfAdvertisement({
  required String name,
  required String title,
  required int sellingPrice,
  required String sellingPoint,
  required String url,
  required String placeOfOrigin,
  required String description,
  required int status,
  required int stock,
  required int productId,
}) {
  PacketClient packet = PacketClient.create();
  InsertRecordOfAdvertisementReq req = InsertRecordOfAdvertisementReq(
    name,
    title,
    sellingPrice,
    sellingPoint,
    placeOfOrigin,
    url,
    stock,
    productId,
    status,
    description,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.insertRecordOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
