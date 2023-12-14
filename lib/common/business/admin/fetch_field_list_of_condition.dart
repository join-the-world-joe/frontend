import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_field_list_of_condition.dart';

void fetchFieldListOfCondition({
  required String from,
  required int behavior,
  required String table,
  required String role,
  required String field,
}) {

  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.fetchFieldListOfConditionReq,
    body: FetchFieldListOfConditionReq.construct(
      behavior: behavior,
      table: table,
      field: field,
      role: role,
    ),
  );
}
