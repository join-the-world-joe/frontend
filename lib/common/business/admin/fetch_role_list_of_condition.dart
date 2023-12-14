import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_role_list_of_condition.dart';

void fetchRoleListOfCondition({
  required String from,
  required int userId,
  required int behavior,
  required List<String> roleNameList,
}) {

  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.fetchRoleListOfConditionReq,
    body: FetchRoleListOfConditionReq.construct(
      behavior: behavior,
      userId: userId,
      roleNameList: roleNameList,
    ),
  );
}
