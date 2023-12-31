import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchRoleListOfCondition({
  required String from,
  required String caller,
  required int userId,
  required int behavior,
  required List<String> roleNameList,
}) {

  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.fetchRoleListOfConditionReq,
    body: FetchRoleListOfConditionReq.construct(
      behavior: behavior,
      userId: userId,
      roleNameList: roleNameList,
    ),
  );
}
