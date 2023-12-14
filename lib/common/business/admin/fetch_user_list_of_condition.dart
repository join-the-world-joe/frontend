import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_user_list_of_condition.dart';

void fetchUserListOfCondition({
  required String from,
  required int behavior,
  required String name,
  required String phoneNumber,
  required int userId,
}) {
  Runtime.request(
    from: from,
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
