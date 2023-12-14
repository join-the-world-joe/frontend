import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_track_list_of_condition.dart';

void fetchTrackListOfCondition({
  required String operator,
  required int behavior,
  required int begin,
  required int end,
  required String major,
  required String minor,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchTrackListOfConditionReq,
    body: FetchTrackListOfConditionReq.construct(
      behavior: behavior,
      operator: operator,
      begin: begin,
      end: end,
      major: major,
      minor: minor,
    ),
  );
}
