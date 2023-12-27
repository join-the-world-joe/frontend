import 'package:flutter_framework/common/protocol/advertisement/fetch_id_list_of_ad_of_carousel.dart';
import 'package:flutter_framework/common/route/advertisement.dart';
import '../../../common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchIdListOfADOfCarousel({
  required String from,
  required String caller,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    body: FetchIdListOfADOfCarouselReq.construct(
      behavior: 1,
    ),
    major: Major.advertisement,
    minor: Advertisement.fetchIdListOfADOfCarouselReq,
  );
}
