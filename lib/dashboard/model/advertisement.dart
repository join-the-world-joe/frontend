import 'dart:convert';

import 'package:flutter_framework/utils/convert.dart';

class Advertisement {
  int _id = 0;
  String _name = '';
  String _title = '';
  String _placeOfOrigin = '';
  List<String> _sellingPoints = [];
  String _image = '';
  int _sellingPrice = 0;
  int _stock = 0;
  int _status = 0;
  int _productId = 0;
  String _thumbnail = '';

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  String getThumbnail() {
    return _thumbnail;
  }

  List<String> getSellingPoints() {
    return _sellingPoints;
  }

  String getImage() {
    return _image;
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
    required String image,
    required int sellingPrice,
    required int stock,
    required int status,
    required int productId,
    required String thumbnail,
  }) {
    _id = id;
    _name = name;
    _title = title;
    _placeOfOrigin = placeOfOrigin;
    _sellingPoints = sellingPoints;
    _image = image;
    _sellingPrice = sellingPrice;
    _stock = stock;
    _status = status;
    _thumbnail = thumbnail;
    _productId = productId;
  }
}
