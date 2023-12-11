import 'dart:convert';
import '../../../utils/convert.dart';

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
