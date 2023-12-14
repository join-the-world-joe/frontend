import 'dart:typed_data';
import 'package:flutter_framework/common/route/advertisement.dart';
import 'package:flutter_framework/dashboard/model/ad_of_deals.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_records_of_ad_of_deals.dart';

void fetchRecordsOfADOfDeals({
  required String from,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    major: Major.advertisement,
    minor: Advertisement.fetchRecordsOfADOfDealsReq,
    body: FetchRecordsOfADOfDealsReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
