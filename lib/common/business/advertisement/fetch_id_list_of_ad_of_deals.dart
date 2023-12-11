import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_version_of_ad_of_deals.dart';

void fetchIdListOfADOfDeals() {
  Runtime.request(
    body: FetchVersionOfADOfDealsReq(),
    major: Major.advertisement,
    minor: Minor.advertisement.fetchIdListOfADOfDealsReq,
  );

  // PacketClient packet = PacketClient.create();
  // FetchIdListOfADOfDealsReq req = FetchIdListOfADOfDealsReq();
  // packet.getHeader().setMajor(Major.advertisement);
  // packet.getHeader().setMinor(Minor.advertisement.fetchIdListOfADOfDealsReq_);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
