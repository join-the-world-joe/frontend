import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class InsertRecordOfAdvertisementReq {
  String _name = '';
  String _title = '';
  int _sellingPrice = 0;
  List<dynamic> _sellingPoints = [];
  String _placeOfOrigin = '';
  String _url = '';
  int _stock = 0;
  int _productId = 0;
  int _status = 0;
  String _description = '';

  InsertRecordOfAdvertisementReq.construct({
    required String name,
    required String title,
    required int sellingPrice,
    required List<String> sellingPoints,
    required String placeOfOrigin,
    required String url,
    required int stock,
    required int productId,
    required int status,
    required String description,
  }) {
    _name = name;
    _title = title;
    _sellingPrice = sellingPrice;
    _sellingPoints = Convert.utf8Encode(sellingPoints);
    _placeOfOrigin = placeOfOrigin;
    _url = url;
    _stock = stock;
    _productId = productId;
    _status = status;
    _description = description;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'title': utf8.encode(_title),
      'selling_points': _sellingPoints,
      'selling_price': _sellingPrice,
      'description': utf8.encode(_description),
      'status': _status,
      "url": utf8.encode(_url),
      "product_id": _productId,
      "stock": _stock,
      "place_of_origin": utf8.encode(_placeOfOrigin),
    };
  }
}

class InsertRecordOfAdvertisementRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  InsertRecordOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}

void insertRecordOfAdvertisement({
  required String name,
  required String title,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String url,
  required String placeOfOrigin,
  required String description,
  required int status,
  required int stock,
  required int productId,
}) {
  PacketClient packet = PacketClient.create();
  InsertRecordOfAdvertisementReq req = InsertRecordOfAdvertisementReq.construct(
    name: name,
    title: title,
    sellingPrice: sellingPrice,
    sellingPoints: sellingPoints,
    placeOfOrigin: placeOfOrigin,
    url: url,
    stock: stock,
    productId: productId,
    status: status,
    description: description,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.insertRecordOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
