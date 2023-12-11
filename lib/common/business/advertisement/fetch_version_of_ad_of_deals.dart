import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_version_of_ad_of_deals.dart';

void fetchVersionOfADOfDeals() {
  Runtime.request(
    body: FetchVersionOfADOfDealsReq(),
    major: Major.advertisement,
    minor: Minor.advertisement.fetchVersionOfADOfDealsReq,
  );
}
