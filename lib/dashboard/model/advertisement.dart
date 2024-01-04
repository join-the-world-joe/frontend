import 'dart:convert';

import 'package:flutter_framework/utils/convert.dart';

class Advertisement {
  int _id = 0;
  String _name = '';
  String _title = '';
  String _placeOfOrigin = '';
  List<String> _sellingPoints = [];
  int _sellingPrice = 0;
  int _stock = 0;
  int _status = 0;
  int _productId = 0;
  String _coverImage = '';
  String _firstImage = '';
  String _secondImage = '';
  String _thirdImage = '';
  String _fourthImage = '';
  String _fifthImage = '';
  String _ossPath = '';
  String _ossFolder = '';

  int getId() {
    return _id;
  }

  String getOSSPath() {
    return _ossPath;
  }

  String getOSSFolder() {
    return _ossFolder;
  }

  String getName() {
    return _name;
  }

  List<String> getSellingPoints() {
    return _sellingPoints;
  }

  String getCoverImage() {
    return _coverImage;
  }

  String getFirstImage() {
    return _firstImage;
  }

  String getSecondImage() {
    return _secondImage;
  }

  String getThirdImage() {
    return _thirdImage;
  }
  String getFourthImage() {
    return _fourthImage;
  }
  String getFifthImage() {
    return _fifthImage;
  }

  int getStock() {
    return _stock;
  }

  int getStatus() {
    return _status;
  }

  int getSellingPrice() {
    return _sellingPrice;
  }

  String getTitle() {
    return _title;
  }

  String getPlaceOfOrigin() {
    return _placeOfOrigin;
  }

  int getProductId() {
    return _productId;
  }

  Advertisement.construct({
    required int id,
    required String name,
    required String title,
    required String placeOfOrigin,
    required List<String> sellingPoints,
    required String coverImage,
    required String firstImage,
    required String secondImage,
    required String thirdImage,
    required String fourthImage,
    required String fifthImage,
    required int sellingPrice,
    required int stock,
    required int status,
    required int productId,
    required String ossPath,
    required String ossFolder,
  }) {
    _id = id;
    _name = name;
    _title = title;
    _placeOfOrigin = placeOfOrigin;
    _sellingPoints = sellingPoints;
    _coverImage = coverImage;
    _firstImage = firstImage;
    _secondImage = secondImage;
    _thirdImage = thirdImage;
    _fourthImage = fourthImage;
    _fifthImage = fifthImage;
    _sellingPrice = sellingPrice;
    _stock = stock;
    _status = status;
    _productId = productId;
    _ossFolder = ossFolder;
    _ossPath = ossPath;
  }
}
