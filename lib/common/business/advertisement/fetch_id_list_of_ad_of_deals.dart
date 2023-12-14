import 'package:flutter_framework/common/protocol/advertisement/fetch_id_list_of_ad_of_deals.dart';
import 'package:flutter_framework/common/route/advertisement.dart';

import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_version_of_ad_of_deals.dart';

void fetchIdListOfADOfDeals({required String from}) {
  Runtime.request(
    from: from,
    body: FetchIdListOfADOfDealsReq.construct(behavior: 1),
    major: Major.advertisement,
    minor: Advertisement.fetchIdListOfADOfDealsReq,
  );
}
