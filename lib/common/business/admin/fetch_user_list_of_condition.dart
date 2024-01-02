import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_user_list_of_condition.dart';

void fetchUserListOfCondition({
  required String from,
  required String caller,
  required int behavior,
  required String name,
  required String phoneNumber,
  required int userId,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.fetchUserListOfConditionReq,
    body: FetchUserListOfConditionReq.construct(
      behavior: behavior,
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
    ),
  );
}
