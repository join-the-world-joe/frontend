import 'dart:convert';

class InsertRecordOfProductReq {
  String _name = '';
  String _vendor = '';
  String _contact = '';
  int _buyingPrice = -1;

  InsertRecordOfProductReq.construct({
    required String name,
    required String vendor,
    required String contact,
    required int buyingPrice,
  }) {
    _name = name;
    _vendor = vendor;
    _contact = contact;
    _buyingPrice = buyingPrice;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'vendor': utf8.encode(_vendor),
      'contact': utf8.encode(_contact),
      'buying_price': _buyingPrice,
    };
  }
}

class InsertRecordOfProductRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  InsertRecordOfProductRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
