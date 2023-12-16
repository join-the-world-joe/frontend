import 'dart:convert';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_advertisement.dart';

void fetchRecordsOfAdvertisement({
  required String from,
  required String caller,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.fetchRecordsOfAdvertisementReq,
    body: FetchRecordsOfAdvertisementReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
