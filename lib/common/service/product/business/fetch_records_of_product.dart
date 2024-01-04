import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/product.dart';
import 'package:flutter_framework/common/service/product/protocol/fetch_records_of_product.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchRecordsOfProduct({
  required String from,
  required String caller,
  required List<int> productIdList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.product,
    minor: Product.fetchRecordsOfProductReq,
    body: FetchRecordsOfProductReq.construct(
      productIdList: productIdList,
    ),
  );
}
