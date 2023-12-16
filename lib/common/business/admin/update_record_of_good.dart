import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_good.dart';

void updateRecordOfGood({
  required String from,
  required String caller,
  required String name,
  required int productId,
  required int buyingPrice,
  required String vendor,
  required String contact,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.updateRecordOfGoodReq,
    body: UpdateRecordOfGoodReq.construct(
      productId: productId,
      name: name,
      buyingPrice: buyingPrice,
      vendor: vendor,
      contact: contact,
    ),
  );
}
