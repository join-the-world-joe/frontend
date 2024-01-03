import 'dart:convert';

class UpdateRecordOfProductReq {
  String _name = '';
  int _productId = -1;
  int _buyingPrice = -1;
  String _vendor = '';
  String _contact = '';

  UpdateRecordOfProductReq.construct({
    required String name,
    required int productId,
    required int buyingPrice,
    required String vendor,
    required String contact,
  }) {
    _name = name;
    _productId = productId;
    _buyingPrice = buyingPrice;
    _vendor = vendor;
    _contact = contact;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'product_id': _productId,
      'buying_price': _buyingPrice,
      'vendor': utf8.encode(_vendor),
      'contact': utf8.encode(_contact),
    };
  }
}

class UpdateRecordOfProductRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  UpdateRecordOfProductRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
