import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_user_list_of_condition.dart';

void insertRecordOfADOfDeals({
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.insertRecordOfADOfDealsReq,
    body: InsertRecordOfADOfDealsReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
