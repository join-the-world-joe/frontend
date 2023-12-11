import 'dart:convert';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_good.dart';

void fetchRecordsOfGood({
  required List<int> productIdList,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchRecordsOfGoodReq,
    body: FetchRecordsOfGoodReq.construct(
      productIdList: productIdList,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // FetchRecordsOfGoodReq req = FetchRecordsOfGoodReq.construct(productIdList: productIdList);
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchRecordsOfGoodReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
