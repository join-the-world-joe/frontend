import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_id_list_of_advertisement.dart';

void fetchIdListOfAdvertisement({
  required int behavior,
  required String advertisementName,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchIdListOfAdvertisementReq,
    body: FetchIdListOfAdvertisementReq.construct(
      behavior: behavior,
      advertisementName: advertisementName,
    ),
  );

  //
  // PacketClient packet = PacketClient.create();
  // FetchIdListOfAdvertisementReq req = FetchIdListOfAdvertisementReq.construct(
  //   behavior: behavior,
  //   advertisementName: advertisementName,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchIdListOfAdvertisementReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
