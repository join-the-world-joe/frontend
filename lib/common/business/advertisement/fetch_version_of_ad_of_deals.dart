import 'package:flutter_framework/common/route/advertisement.dart';

import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_version_of_ad_of_deals.dart';

void fetchVersionOfADOfDeals({
  required String from,
  required String caller,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    body: FetchVersionOfADOfDealsReq(),
    major: Major.advertisement,
    minor: Advertisement.fetchVersionOfADOfDealsReq,
  );
}
