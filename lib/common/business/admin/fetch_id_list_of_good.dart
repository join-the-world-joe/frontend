import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_id_list_of_good.dart';

void fetchIdListOfGood({
  required String from,
  required int behavior,
  required String productName,
  required int categoryId,
}) {
  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.fetchIdListOfGoodReq,
    body:  FetchIdListOfGoodReq.construct(
      behavior: behavior,
      productName: productName,
      categoryId: categoryId,
    ),
  );
}
