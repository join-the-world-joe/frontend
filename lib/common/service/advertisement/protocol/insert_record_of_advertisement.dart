import 'dart:convert';
import 'package:flutter_framework/utils/convert.dart';

class InsertRecordOfAdvertisementReq {
  String _name = '';
  String _title = '';
  int _sellingPrice = 0;
  List<dynamic> _sellingPoints = [];
  String _placeOfOrigin = '';
  String _coverImage = '';
  String _firstImage = '';
  String _secondImage = '';
  String _thirdImage = '';
  String _fourthImage = '';
  String _fifthImage = '';
  int _stock = 0;
  int _productId = 0;

  InsertRecordOfAdvertisementReq.construct({
    required String name,
    required String title,
    required int sellingPrice,
    required List<String> sellingPoints,
    required String placeOfOrigin,
    required String coverImage,
    required String firstImage,
    required String secondImage,
    required String thirdImage,
    required String fourthImage,
    required String fifthImage,
    required int stock,
    required int productId,
  }) {
    _name = name;
    _title = title;
    _sellingPrice = sellingPrice;
    _sellingPoints = Convert.utf8EncodeListString(sellingPoints);
    _placeOfOrigin = placeOfOrigin;
    _stock = stock;
    _productId = productId;
    _coverImage = coverImage;
    _firstImage = firstImage;
    _secondImage = secondImage;
    _thirdImage = thirdImage;
    _fourthImage = fourthImage;
    _fifthImage = fifthImage;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': Convert.utf8Encode(_name),
      'title': Convert.utf8Encode(_title),
      'selling_points': _sellingPoints,
      'selling_price': _sellingPrice,
      "cover_image": Convert.utf8Encode(_coverImage),
      "first_image": Convert.utf8Encode(_firstImage),
      "second_image": Convert.utf8Encode(_secondImage),
      "third_image": Convert.utf8Encode(_thirdImage),
      "fourth_image": Convert.utf8Encode(_fourthImage),
      "fifth_image": Convert.utf8Encode(_fifthImage),
      "product_id": _productId,
      "stock": _stock,
      "place_of_origin": Convert.utf8Encode(_placeOfOrigin),
    };
  }
}

class InsertRecordOfAdvertisementRsp {
  int _code = -1;
  int _advertisementId = -1;

  int getCode() {
    return _code;
  }

  int getAdvertisementId() {
    return _advertisementId;
  }

  InsertRecordOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('advertisement_id')) {
        _advertisementId = body['advertisement_id'];
      }
    }
  }
}
