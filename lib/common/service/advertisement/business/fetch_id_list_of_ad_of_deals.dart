import 'package:flutter_framework/common/route/advertisement.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_id_list_of_ad_of_deals.dart';
import '../../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchIdListOfADOfDeals({
  required String from,
  required String caller,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    body: FetchIdListOfADOfDealsReq.construct(
      behavior: 1,
    ),
    major: Major.advertisement,
    minor: Advertisement.fetchIdListOfADOfDealsReq,
  );
}
