import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/product.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/product/fetch_id_list_of_product.dart';

void fetchIdListOfProduct({
  required String from,
  required String caller,
  required int behavior,
  required String productName,
  required int categoryId,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.product,
    minor: Product.fetchIdListOfProductReq,
    body: FetchIdListOfProductReq.construct(
      behavior: behavior,
      productName: productName,
      categoryId: categoryId,
    ),
  );
}
