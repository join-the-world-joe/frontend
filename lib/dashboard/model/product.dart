import 'dart:convert';

class Product {
  final String _id;
  final String _name;
  final String _buyingPrice;
  final String _description;
  final String _status;
  final String _vendor;
  final String _createdAt;
  final String _contact;
  final String _updatedAt;

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  String getBuyingPrice() {
    return _buyingPrice;
  }

  String getDescription() {
    return _description;
  }

  String getStatus() {
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

  Product(
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

// factory Product.fromJson(Map<String, dynamic> json) {
//   String id = "null", buyingPrice = "null", status = "null", vendor = "null", updatedAt = "null";
//   String name = 'null', description = 'null', createdAt = 'null', contact = "null";
//   int rank = 0;
//   try {
//     name = json['name'] ?? 'Empty';
//     description = json['description'] ?? 'Empty';
//     rank = json['rank'] ?? 'Empty';
//     department = json['department'] ?? 'Empty';
//   } catch (e) {
//     print('e: $e');
//   }
//   return Product(name, rank, description, department);
// }
}
