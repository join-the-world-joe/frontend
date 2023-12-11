import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_good.dart';

void updateRecordOfGood({
  required String name,
  required int productId,
  required int buyingPrice,
  required int status,
  required String vendor,
  required String contact,
  required String description,
}) {

  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.updateRecordOfGoodReq,
    body:  UpdateRecordOfGoodReq.construct(
      productId: productId,
      name: name,
      buyingPrice: buyingPrice,
      status: status,
      vendor: vendor,
      contact: contact,
      description: description,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // UpdateRecordOfGoodReq req = UpdateRecordOfGoodReq.construct(
  //   productId: productId,
  //   name: name,
  //   buyingPrice: buyingPrice,
  //   status: status,
  //   vendor: vendor,
  //   contact: contact,
  //   description: description,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.updateRecordOfGoodReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
