import 'dart:convert';
import '../../../utils/convert.dart';

class InsertRecordOfAdvertisementReq {
  String _name = '';
  String _title = '';
  int _sellingPrice = 0;
  List<dynamic> _sellingPoints = [];
  String _placeOfOrigin = '';
  String _image = '';
  int _stock = 0;
  int _productId = 0;
  dynamic _thumbnail = '';

  InsertRecordOfAdvertisementReq.construct({
    required String name,
    required String title,
    required int sellingPrice,
    required List<String> sellingPoints,
    required String placeOfOrigin,
    required String image,
    required int stock,
    required int productId,
    required String thumbnail,
  }) {
    _name = name;
    _title = title;
    _sellingPrice = sellingPrice;
    _sellingPoints = Convert.utf8EncodeListString(sellingPoints);
    _placeOfOrigin = placeOfOrigin;
    _image = image;
    _stock = stock;
    _productId = productId;
    _thumbnail = thumbnail;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': Convert.utf8Encode(_name),
      'title': Convert.utf8Encode(_title),
      'selling_points': _sellingPoints,
      'selling_price': _sellingPrice,
      "image": Convert.utf8Encode(_image),
      "product_id": _productId,
      "stock": _stock,
      "place_of_origin": Convert.utf8Encode(_placeOfOrigin),
      "thumbnail": Convert.utf8Encode(_thumbnail),
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
