import 'package:flutter_framework/common/route/advertisement.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_records_of_ad_of_carousel.dart';
import '../../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchRecordsOfADOfCarousel({
  required String from,
  required String caller,
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.advertisement,
    minor: Advertisement.fetchRecordsOfADOfCarouselReq,
    body: FetchRecordsOfADOfCarouselReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );
}
