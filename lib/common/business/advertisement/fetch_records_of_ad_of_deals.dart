import 'package:flutter_framework/common/route/advertisement.dart';
import '../../../common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_records_of_ad_of_deals.dart';

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
