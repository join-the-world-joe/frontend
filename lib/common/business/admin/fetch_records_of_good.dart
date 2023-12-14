import 'dart:convert';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_good.dart';

void fetchRecordsOfGood({
  required String from,
  required List<int> productIdList,
}) {
  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.fetchRecordsOfGoodReq,
    body: FetchRecordsOfGoodReq.construct(
      productIdList: productIdList,
    ),
  );
}
