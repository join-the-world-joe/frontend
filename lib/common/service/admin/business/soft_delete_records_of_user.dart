import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_user.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void softDeleteRecordsOfUser({
  required String from,
  required String caller,
  required List<int> userList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.softDeleteRecordOfUserReq,
    body: SoftDeleteRecordsOfUserReq.construct(
      userIdList: userList,
    ),
  );
}
