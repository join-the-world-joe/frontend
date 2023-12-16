import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_user_record.dart';

void softDeleteUserRecord({
  required String from,
  required String caller,
  required List<int> userList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.softDeleteUserRecordReq,
    body: SoftDeleteUserRecordReq.construct(
      userIdList: userList,
    ),
  );
}
