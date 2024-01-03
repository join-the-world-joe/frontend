import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void insertRecordOfADOfDeals({
  required String from,
  required String caller,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.insertRecordOfADOfDealsReq,
    body: InsertRecordOfADOfDealsReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
