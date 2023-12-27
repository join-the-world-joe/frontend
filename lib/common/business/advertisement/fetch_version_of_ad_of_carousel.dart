import 'package:flutter_framework/common/protocol/advertisement/fetch_version_of_ad_of_carousel.dart';
import 'package:flutter_framework/common/route/advertisement.dart';
import '../../../common/route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchVersionOfADOfCarousel({
  required String from,
  required String caller,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    body: FetchVersionOfADOfCarouselReq(),
    major: Major.advertisement,
    minor: Advertisement.fetchVersionOfADOfCarouselReq,
  );
}
