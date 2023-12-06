import 'dart:convert';

class Advertisement {
  final int _id;
  final String _name;
  final int _buyingPrice;
  final String _description;
  final int _status;
  final String _vendor;
  final String _createdAt;
  final String _contact;
  final String _updatedAt;

  int getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  int getBuyingPrice() {
    return _buyingPrice;
  }

  String getDescription() {
    return _description;
  }

  int getStatus() {
    return _status;
  }

  String getVendor() {
    return _vendor;
  }

  String getCreatedAt() {
    return _createdAt;
  }

  String getUpdatedAt() {
    return _updatedAt;
  }

  String getContact() {
    return _contact;
  }

  Advertisement(
    this._id,
    this._name,
    this._buyingPrice,
    this._description,
    this._status,
    this._vendor,
    this._createdAt,
    this._contact,
    this._updatedAt,
  );
}
