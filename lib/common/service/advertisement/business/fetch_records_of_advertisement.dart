import 'package:flutter_framework/common/route/advertisement.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_records_of_advertisement.dart';

void fetchRecordsOfAdvertisement({
  required String from,
  required String caller,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.advertisement,
    minor: Advertisement.fetchRecordsOfAdvertisementReq,
    body: FetchRecordsOfAdvertisementReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
