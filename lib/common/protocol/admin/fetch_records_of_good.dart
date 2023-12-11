import 'package:flutter_framework/dashboard/model/product.dart';

class FetchRecordsOfGoodReq {
  List<int> _productIdList = [];

  FetchRecordsOfGoodReq.construct({
    required List<int> productIdList,
  }) {
    _productIdList = productIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id_list': _productIdList,
    };
  }
}

class FetchRecordsOfGoodRsp {
  int _code = -1;
  Map<int, Product> _productMap = {};

  int getCode() {
    return _code;
  }

  Map<int, Product> getProductMap() {
    return _productMap;
  }

  FetchRecordsOfGoodRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('records_of_good')) {
        final Map some = Map.from(body['records_of_good']);
        some.forEach(
              (key, value) {
            _productMap[value['id']] = Product.construct(
              id: value['id'],
              name: value['name'],
              buyingPrice: value['buying_price'],
              description: value['description'],
              status: value['status'],
              vendor: value['vendor'],
              createdAt: value['created_at'],
              contact: value['contact'],
              updatedAt: value['updated_at'],
            );
          },
        );
      }
    }
  }
}