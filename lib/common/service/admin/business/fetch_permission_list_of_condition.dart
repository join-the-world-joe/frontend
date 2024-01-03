import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchPermissionListOfCondition({
  required String from,
  required String caller,
  required String name,
  required String major,
  required String minor,
  required int userId,
  required int behavior,
  required RoleList roleList,
}) {

  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.fetchPermissionListOfConditionReq,
    body:FetchPermissionListOfConditionReq.construct(
      name: name,
      major: major,
      minor: minor,
      userId: userId,
      behavior: behavior,
      roleList: roleList,
    ),
  );
}
