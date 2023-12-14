import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_id_list_of_advertisement.dart';

void fetchIdListOfAdvertisement({
  required String from,
  required int behavior,
  required String advertisementName,
}) {
  Runtime.request(
    from: from,
    major: Major.admin,
    minor: Admin.fetchIdListOfAdvertisementReq,
    body: FetchIdListOfAdvertisementReq.construct(
      behavior: behavior,
      advertisementName: advertisementName,
    ),
  );
}
