import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_product.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void softDeleteRecordsOfProduct({
  required String from,
  required String caller,
  required List<int> productIdList,
}) {

  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.softDeleteRecordsOfProductReq,
    body: SoftDeleteRecordsOfProductReq.construct(
      productIdList: productIdList,
    ),
  );
}
