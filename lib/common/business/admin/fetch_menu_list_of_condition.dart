import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_menu_list_of_condition.dart';

void fetchMenuListOfCondition({
  required String from,
  required int behavior,
  required int userId,
  required RoleList roleList,
}) {
  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.fetchMenuListOfConditionReq,
    body: FetchMenuListOfConditionReq.construct(
      behavior: behavior,
      userId: userId,
      roleList: roleList,
    ),
  );
}
