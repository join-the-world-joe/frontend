import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_track_list_of_condition.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchTrackListOfCondition({
  required String from,
  required String caller,
  required String operator,
  required int behavior,
  required int begin,
  required int end,
  required String major,
  required String minor,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.fetchTrackListOfConditionReq,
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
