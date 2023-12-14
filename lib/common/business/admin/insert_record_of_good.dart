import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_good.dart';

void insertRecordOfGood({
  required String from,
  required String name,
  required String vendor,
  required String contact,
  required int buyingPrice,
}) {
  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.insertRecordOfGoodReq,
    body: InsertRecordOfGoodReq.construct(
      name: name,
      vendor: vendor,
      contact: contact,
      buyingPrice: buyingPrice,
    ),
  );
}
