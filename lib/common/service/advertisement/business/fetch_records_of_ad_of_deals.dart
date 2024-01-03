import 'package:flutter_framework/common/route/advertisement.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_records_of_ad_of_deals.dart';
import '../../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchRecordsOfADOfDeals({
  required String from,
  required String caller,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.advertisement,
    minor: Advertisement.fetchRecordsOfADOfDealsReq,
    body: FetchRecordsOfADOfDealsReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
