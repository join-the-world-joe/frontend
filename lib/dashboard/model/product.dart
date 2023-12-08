import 'dart:convert';

class Product {
  late int _id;
  late String _name;
  late int _buyingPrice;
  late String _description;
  late int _status;
  late String _vendor;
  late String _createdAt;
  late String _contact;
  late String _updatedAt;

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

  Product.construct({
    required int id,
    required String name,
    required int buyingPrice,
    required String description,
    required int status,
    required String vendor,
    required String createdAt,
    required String contact,
    required String updatedAt,
  }) {
    _id = id;
    _name = name;
    _buyingPrice = buyingPrice;
    _description = description;
    _status = status;
    _vendor = vendor;
    _createdAt = createdAt;
    _contact = contact;
    _updatedAt = updatedAt;
  }
}
