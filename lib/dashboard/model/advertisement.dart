import 'dart:convert';

import 'package:flutter_framework/utils/convert.dart';

class Advertisement {
  late int _id;
  late String _name;
  late String _title;
  late String _placeOfOrigin;
  late List<String> _sellingPoints;
  late String _url;
  late int _sellingPrice;
  late String _description;
  late int _status;
  late int _stock;
  late int _productId;

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  List<String> getSellingPoints() {
    return _sellingPoints;
  }

  String getUrl() {
    return _url;
  }

  int getStock() {
    return _stock;
  }

  int getSellingPrice() {
    return _sellingPrice;
  }

  String getDescription() {
    return _description;
  }

  int getStatus() {
    return _status;
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
    required String url,
    required int sellingPrice,
    required String description,
    required int status,
    required int stock,
    required int productId,
  }) {
    _id = id;
    _name = name;
    _title = title;
    _placeOfOrigin = placeOfOrigin;
    _sellingPoints = sellingPoints;
    _url = url;
    _sellingPrice = sellingPrice;
    _description = description;
    _stock = stock;
    _status = status;
    _productId = productId;
  }
}
