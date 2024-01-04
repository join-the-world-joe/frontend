import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_user_record.dart';

void updateUserRecord({
  required String from,
  required String caller,
  required String name,
  required int userId,
  required String phoneNumber,
  required String countryCode,
  required int status,
  required Uint8List password,
  required List<String> roleList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.updateRecordOfUserReq,
    body: UpdateUserRecordReq.construct(
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      status: status,
      password: password,
      roleList: roleList,
    ),
  );
}
