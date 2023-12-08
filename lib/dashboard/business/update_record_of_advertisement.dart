import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class UpdateRecordOfAdvertisementReq {
  int _id = 0;
  String _name = '';
  String _title = '';
  int _productId = 0;
  int _sellingPrice = 0;
  String _placeOfOrigin = '';
  int _status = 0;
  List<String> _sellingPoints = [];
  String _url = '';
  int _stock = 0;
  String _description = '';

  UpdateRecordOfAdvertisementReq.construct({
    required int id,
    required String name,
    required String title,
    required int productId,
    required int sellingPrice,
    required String placeOfOrigin,
    required int status,
    required List<String> sellingPoints,
    required String url,
    required int stock,
    required String description,
  }) {
    print('id: $id');
    _id = id;
    _name = name;
    _title = title;
    _productId = productId;
    _sellingPrice = sellingPrice;
    _placeOfOrigin = placeOfOrigin;
    _sellingPoints = sellingPoints;
    _status = status;
    _url = url;
    _stock = stock;
    _description = description;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': utf8.encode(_name),
      'title': utf8.encode(_title),
      'stock': _stock,
      'product_id': _productId,
      'selling_points': Convert.utf8Encode(_sellingPoints),
      'selling_price': _sellingPrice,
      'url': utf8.encode(_url),
      'status': _status,
      'place_of_origin': utf8.encode(_placeOfOrigin),
      'description': utf8.encode(_description),
    };
  }
}

class UpdateRecordOfAdvertisementRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  UpdateRecordOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}

void updateRecordOfAdvertisement({
  required int id,
  required String url,
  required String name,
  required String title,
  required int stock,
  required int productId,
  required int sellingPrice,
  required int status,
  required List<String> sellingPoints,
  required String placeOfOrigin,
  required String description,
}) {
  PacketClient packet = PacketClient.create();
  UpdateRecordOfAdvertisementReq req = UpdateRecordOfAdvertisementReq.construct(
    id: id,
    url: url,
    name: name,
    status: status,
    title: title,
    stock: stock,
    productId: productId,
    sellingPrice: sellingPrice,
    sellingPoints: sellingPoints,
    placeOfOrigin: placeOfOrigin,
    description: description,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.updateRecordOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
