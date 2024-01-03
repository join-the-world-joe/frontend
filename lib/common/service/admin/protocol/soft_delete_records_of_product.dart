class SoftDeleteRecordsOfProductReq {
  List<int> _productIdList = [];

  SoftDeleteRecordsOfProductReq.construct({required List<int> productIdList}) {
    _productIdList = productIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id_list': _productIdList,
    };
  }
}

class SoftDeleteRecordsOfProductRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  SoftDeleteRecordsOfProductRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
