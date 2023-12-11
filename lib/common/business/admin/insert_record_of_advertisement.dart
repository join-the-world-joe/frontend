import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_advertisement.dart';

void insertRecordOfAdvertisement({
  required String name,
  required String title,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String url,
  required String placeOfOrigin,
  required String description,
  required int status,
  required int stock,
  required int productId,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.insertRecordOfAdvertisementReq,
    body: InsertRecordOfAdvertisementReq.construct(
      name: name,
      title: title,
      sellingPrice: sellingPrice,
      sellingPoints: sellingPoints,
      placeOfOrigin: placeOfOrigin,
      url: url,
      stock: stock,
      productId: productId,
      status: status,
      description: description,
    ),
  );

  //
  // PacketClient packet = PacketClient.create();
  // InsertRecordOfAdvertisementReq req = InsertRecordOfAdvertisementReq.construct(
  //   name: name,
  //   title: title,
  //   sellingPrice: sellingPrice,
  //   sellingPoints: sellingPoints,
  //   placeOfOrigin: placeOfOrigin,
  //   url: url,
  //   stock: stock,
  //   productId: productId,
  //   status: status,
  //   description: description,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.insertRecordOfAdvertisementReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
