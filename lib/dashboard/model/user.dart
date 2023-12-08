import 'dart:html';

class User {
  String _id = '';
  String _name = '';
  String _account = '';
  String _email = '';
  String _department = '';
  String _countryCode = '';
  String _phoneNumber = '';
  String _status = '';
  String _createdAt = '';

  String getId() {
    return _id;
  }

  String getName() {
    return _name;
  }

  String getCreatedAt() {
    return _createdAt;
  }

  String getCountryCode() {
    return _countryCode;
  }

  String getPhoneNumber() {
    return _phoneNumber;
  }

  String getStatus() {
    return _status;
  }

  User.construct({
    required String id,
    required String name,
    required String account,
    required String email,
    required String department,
    required String countryCode,
    required String phoneNumber,
    required String status,
    required String createdAt,
  }) {
    _id = id;
    _name = name;
    _account = account;
    _email = email;
    _department = department;
    _countryCode = _countryCode;
    _phoneNumber = phoneNumber;
    _status = status;
    _createdAt = createdAt;
  }

  // User(
  //   this._id,
  //   this._name,
  //   this._account,
  //   this._email,
  //   this._department,
  //   this._countryCode,
  //   this._phoneNumber,
  //   this._status,
  //   this._createdAt,
  // );

  // factory User.fromJson(Map<String, dynamic> json) {
  //   String id = 'null', name = 'null', account = 'null', email = 'null', department = 'null', countryCode = 'null', phoneNumber = 'null', status = 'null', createdAt = 'null';
  //   try {
  //     id = json['id'] ?? 'Empty';
  //     name = json['name'] ?? 'Empty';
  //     account = json['account'] ?? 'Empty';
  //     email = json['email'] ?? 'Empty';
  //     department = json['department'] ?? 'Empty';
  //     countryCode = json['country_code'] ?? 'Empty';
  //     phoneNumber = json['phone_number'] ?? 'Empty';
  //     status = json['status'] ?? 'Empty';
  //     createdAt = json['created_at'] ?? 'Empty';
  //   } catch (e) {
  //     print('e: $e');
  //   }
  //   return User.construct(
  //     id:id,
  //     name,
  //     account,
  //     email,
  //     department,
  //     countryCode,
  //     phoneNumber,
  //     status,
  //     createdAt,
  //   );
  // }
}
