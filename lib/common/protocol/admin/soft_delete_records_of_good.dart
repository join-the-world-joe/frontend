
class SoftDeleteRecordsOfGoodReq {
  List<int> _productIdList = [];

  SoftDeleteRecordsOfGoodReq.construct({required List<int> productIdList}) {
    _productIdList = productIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id_list': _productIdList,
    };
  }
}

class SoftDeleteRecordsOfGoodRsp {
  int code = -1;

  SoftDeleteRecordsOfGoodRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}
