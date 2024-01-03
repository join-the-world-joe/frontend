import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_field_list_of_condition.dart';

void fetchFieldListOfCondition({
  required String from,
  required String caller,
  required int behavior,
  required String table,
  required String role,
  required String field,
}) {

  Runtime.request(
    from: from,
    caller: caller,
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
