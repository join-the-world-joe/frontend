import 'dart:convert';

class UpdateRecordOfGoodReq {
  String _name = '';
  int _productId = -1;
  int _buyingPrice = -1;
  int _status = 0;
  String _vendor = '';
  String _contact = '';
  String _description = '';

  UpdateRecordOfGoodReq.construct({
    required String name,
    required int productId,
    required int buyingPrice,
    required int status,
    required String vendor,
    required String contact,
    required String description,
  }) {
    _name = name;
    _productId = productId;
    _buyingPrice = buyingPrice;
    _status = status;
    _vendor = vendor;
    _contact = contact;
    _description = description;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'product_id': _productId,
      'buying_price': _buyingPrice,
      'vendor': utf8.encode(_vendor),
      'status': _status,
      'contact': utf8.encode(_contact),
      'description': utf8.encode(_description),
    };
  }
}

class UpdateRecordOfGoodRsp {
  int code = -1;

  UpdateRecordOfGoodRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}
