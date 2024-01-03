import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import '../protocol/check_permission.dart';

void checkPermission({
  required String from,
  required String caller,
  required String major,
  required String minor,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.checkPermissionReq,
    body: CheckPermissionReq.construct(
      major: int.parse(major),
      minor: int.parse(minor),
    ),
  );
}
