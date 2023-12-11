import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_records_of_good.dart';

void softDeleteRecordsOfGood({
  required List<int> productIdList,
}) {

  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.softDeleteRecordsOfGoodReq,
    body: SoftDeleteRecordsOfGoodReq.construct(
      productIdList: productIdList,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // SoftDeleteRecordsOfGoodReq req = SoftDeleteRecordsOfGoodReq.construct(
  //   productIdList: productIdList,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.softDeleteRecordsOfGoodReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
