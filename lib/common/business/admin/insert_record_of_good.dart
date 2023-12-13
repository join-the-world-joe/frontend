import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_good.dart';

void insertRecordOfGood({
  required String name,
  required String vendor,
  required String contact,
  required int buyingPrice,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.insertRecordOfGoodReq,
    body: InsertRecordOfGoodReq.construct(
      name: name,
      vendor: vendor,
      contact: contact,
      buyingPrice: buyingPrice,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // InsertRecordOfGoodReq req = InsertRecordOfGoodReq.construct(
  //   name: name,
  //   vendor: vendor,
  //   contact: contact,
  //   buyingPrice: buyingPrice,
  //   description: description,
  //   status: status,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.insertRecordOfGoodReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
