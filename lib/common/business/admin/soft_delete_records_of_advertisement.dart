import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_records_of_advertisement.dart';

void softDeleteRecordsOfAdvertisement({
  required String from,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.softDeleteRecordsOfAdvertisementReq,
    body: SoftDeleteRecordsOfAdvertisementReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
