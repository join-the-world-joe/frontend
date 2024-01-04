import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_user_record.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void insertRecordOfUser({
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
    minor: Admin.insertRecordOfUserReq,
    body: InsertRecordOfUserReq.construct(
      name: name,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      status: status,
      password: password,
      roleList: roleList,
    ),
  );
}
