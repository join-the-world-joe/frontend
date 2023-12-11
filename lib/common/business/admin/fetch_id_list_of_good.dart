import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_id_list_of_good.dart';

void fetchIdListOfGood({
  required int behavior,
  required String productName,
  required int categoryId,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchIdListOfGoodReq,
    body:  FetchIdListOfGoodReq.construct(
      behavior: behavior,
      productName: productName,
      categoryId: categoryId,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // FetchIdListOfGoodReq req = FetchIdListOfGoodReq.construct(
  //   behavior: behavior,
  //   productName: productName,
  //   categoryId: categoryId,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchIdListOfGoodReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
