import 'dart:convert';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_advertisement.dart';

void fetchRecordsOfAdvertisement({
  required List<int> advertisementIdList,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchRecordsOfAdvertisementReq,
    body: FetchRecordsOfAdvertisementReq.construct(
      advertisementIdList: advertisementIdList,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // FetchRecordsOfAdvertisementReq req = FetchRecordsOfAdvertisementReq.construct(
  //   advertisementIdList: advertisementIdList,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchRecordsOfAdvertisementReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
