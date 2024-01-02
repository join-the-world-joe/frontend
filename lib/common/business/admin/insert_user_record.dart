import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/insert_user_record.dart';

void insertUserRecord({
  required String from,
  required String caller,
  required String name,
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
    minor: Admin.insertUserRecordReq,
    body: InsertUserRecordReq.construct(
      name: name,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      status: status,
      password: password,
      roleList: roleList,
    ),
  );
}
