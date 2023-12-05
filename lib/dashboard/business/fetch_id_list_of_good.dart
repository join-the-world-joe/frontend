import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchIdListOfGoodReq {
  final int _behavior;
  final String _productName;
  final int _categoryId;

  FetchIdListOfGoodReq(this._behavior, this._productName, this._categoryId);

  Map<String, dynamic> toJson() => {
        'behavior': _behavior,
        'product_name': _productName,
        'category_id': _categoryId,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchIdListOfGoodRsp {
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

  FetchIdListOfGoodRsp.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null) {
      _code = json['code'] ?? -1;
    }
    if (json['body'] != null) {
      var body = json['body'];
      if (body['id_list_of_good'] != null) {
        _idList = List<int>.from(body['id_list_of_good'] as List);
      }
    }
  }
}

void fetchIdListOfGood({
  required int behavior,
  required String productName,
  required int categoryId,
}) {
  PacketClient packet = PacketClient.create();
  FetchIdListOfGoodReq req = FetchIdListOfGoodReq(behavior, productName, categoryId);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchIdListOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
