import 'dart:convert';
import 'dart:typed_data';
import '../../../../utils/convert.dart';

class FetchIdListOfProductReq {
  int _behavior = -1;
  String _productName = '';
  int _categoryId = -1;

  FetchIdListOfProductReq.construct({
    required int behavior,
    required String productName,
    required int categoryId,
  }) {
    _behavior = behavior;
    _productName = productName;
    _categoryId = categoryId;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'product_name': utf8.encode(_productName),
      'category_id': _categoryId,
    };
  }
}

class FetchIdListOfProductRsp {
  int _code = -1;
  int _behavior = -1;
  List<int> _idList = [];

  int getCode() {
    return _code;
  }

  List<int> getIdList() {
    return _idList;
  }

  int getBehavior() {
    return _behavior;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  FetchIdListOfProductRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('behavior')) {
        _behavior = body['behavior'];
      }
      if (body.containsKey('id_list_of_product')) {
        _idList = List<int>.from(body['id_list_of_product'] as List);
      }
    }
  }
}

