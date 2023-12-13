import 'dart:convert';
import '../../../utils/convert.dart';

class UpdateRecordOfAdvertisementReq {
  int _id = 0;
  String _name = '';
  String _title = '';
  int _productId = 0;
  int _sellingPrice = 0;
  String _placeOfOrigin = '';
  List<String> _sellingPoints = [];
  String _image = '';
  int _stock = 0;
  int _status = 0;
  String _thumbnail = '';

  UpdateRecordOfAdvertisementReq.construct({
    required int id,
    required String name,
    required String title,
    required int productId,
    required int sellingPrice,
    required String placeOfOrigin,
    required List<String> sellingPoints,
    required String image,
    required String thumbnail,
    required int stock,
    required int status,
  }) {
    _id = id;
    _name = name;
    _title = title;
    _productId = productId;
    _sellingPrice = sellingPrice;
    _placeOfOrigin = placeOfOrigin;
    _sellingPoints = sellingPoints;
    _image = image;
    _stock = stock;
    _status = status;
    _thumbnail = thumbnail;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': utf8.encode(_name),
      'title': utf8.encode(_title),
      'stock': _stock,
      'status':_status,
      'product_id': _productId,
      'selling_points': Convert.utf8EncodeListString(_sellingPoints),
      'selling_price': _sellingPrice,
      'image': utf8.encode(_image),
      'place_of_origin': utf8.encode(_placeOfOrigin),
      'thumbnail': utf8.encode(_thumbnail),
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
