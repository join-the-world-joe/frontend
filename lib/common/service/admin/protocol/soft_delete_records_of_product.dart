
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
  int code = -1;

  SoftDeleteRecordsOfProductRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}
