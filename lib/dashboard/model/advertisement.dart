import 'dart:convert';

class Advertisement {
  final int _id;
  final String _name;
  final String _title;
  final String _placeOfOrigin;
  final String _sellingPoint;
  final String _url;
  final int _sellingPrice;
  final String _description;
  final int _status;
  final int _stock;
  final int _productId;

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  String getSellingPoint() {
    return _sellingPoint;
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

  Advertisement(
    this._id,
    this._name,
    this._title,
    this._placeOfOrigin,
    this._sellingPoint,
    this._url,
    this._sellingPrice,
    this._description,
    this._status,
    this._stock,
    this._productId,
  );
}
