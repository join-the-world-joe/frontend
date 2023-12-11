import 'dart:convert';

class InsertRecordOfGoodReq {
  String _name = '';
  String _vendor = '';
  String _contact = '';
  int _buyingPrice = -1;
  String _description = '';
  int _status = 0;

  InsertRecordOfGoodReq.construct({
    required String name,
    required String vendor,
    required String contact,
    required int buyingPrice,
    required String description,
    required int status,
  }) {
    _name = name;
    _vendor = vendor;
    _contact = contact;
    _buyingPrice = buyingPrice;
    _description = description;
    _status = status;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'vendor': utf8.encode(_vendor),
      'contact': utf8.encode(_contact),
      'buying_price': _buyingPrice,
      'description': utf8.encode(_description),
      'status': _status,
    };
  }
}

class InsertRecordOfGoodRsp {
  int code = -1;

  InsertRecordOfGoodRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}