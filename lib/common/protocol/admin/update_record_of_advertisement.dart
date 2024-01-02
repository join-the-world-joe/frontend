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
  String _coverImage = '';
  String _firstImage = '';
  String _secondImage = '';
  String _thirdImage = '';
  String _fourthImage = '';
  String _fifthImage = '';
  int _stock = 0;
  int _status = 0;

  UpdateRecordOfAdvertisementReq.construct({
    required int id,
    required String name,
    required String title,
    required int productId,
    required int sellingPrice,
    required String placeOfOrigin,
    required List<String> sellingPoints,
    required String coverImage,
    required String firstImage,
    required String secondImage,
    required String thirdImage,
    required String fourthImage,
    required String fifthImage,
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
    _coverImage = coverImage;
    _firstImage = firstImage;
    _secondImage = secondImage;
    _thirdImage = thirdImage;
    _fourthImage = fourthImage;
    _fifthImage = fifthImage;
    _stock = stock;
    _status = status;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': utf8.encode(_name),
      'title': utf8.encode(_title),
      'stock': _stock,
      'status': _status,
      'product_id': _productId,
      'selling_points': Convert.utf8EncodeListString(_sellingPoints),
      'selling_price': _sellingPrice,
      'cover_image': utf8.encode(_coverImage),
      "first_image": Convert.utf8Encode(_firstImage),
      "second_image": Convert.utf8Encode(_secondImage),
      "third_image": Convert.utf8Encode(_thirdImage),
      "fourth_image": Convert.utf8Encode(_fourthImage),
      "fifth_image": Convert.utf8Encode(_fifthImage),
      'place_of_origin': utf8.encode(_placeOfOrigin),
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
