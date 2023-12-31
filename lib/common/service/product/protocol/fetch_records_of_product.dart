import 'package:flutter_framework/dashboard/model/product.dart';

class FetchRecordsOfProductReq {
  List<int> _productIdList = [];

  FetchRecordsOfProductReq.construct({
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

class FetchRecordsOfProductRsp {
  int _code = -1;
  Map<int, Product> _dataMap = {};

  int getCode() {
    return _code;
  }

  Map<int, Product> getDataMap() {
    return _dataMap;
  }

  FetchRecordsOfProductRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('records_of_product')) {
        final Map some = Map.from(body['records_of_product']);
        some.forEach(
          (key, value) {
            _dataMap[value['id']] = Product.construct(
              id: value['id'],
              name: value['name'],
              buyingPrice: value['buying_price'],
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
