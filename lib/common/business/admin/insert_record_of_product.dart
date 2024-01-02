import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_product.dart';

void insertRecordOfProduct({
  required String from,
  required String caller,
  required String name,
  required String vendor,
  required String contact,
  required int buyingPrice,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.insertRecordOfProductReq,
    body: InsertRecordOfProductReq.construct(
      name: name,
      vendor: vendor,
      contact: contact,
      buyingPrice: buyingPrice,
    ),
  );
}
