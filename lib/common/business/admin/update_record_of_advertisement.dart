import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_advertisement.dart';

void updateRecordOfAdvertisement({
  required int id,
  required String image,
  required String name,
  required String title,
  required int stock,
  required int productId,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String placeOfOrigin,
  required String thumbnail,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.updateRecordOfAdvertisementReq,
    body: UpdateRecordOfAdvertisementReq.construct(
      id: id,
      image: image,
      name: name,
      title: title,
      stock: stock,
      productId: productId,
      sellingPrice: sellingPrice,
      sellingPoints: sellingPoints,
      placeOfOrigin: placeOfOrigin,
      thumbnail: thumbnail,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // UpdateRecordOfAdvertisementReq req = UpdateRecordOfAdvertisementReq.construct(
  //   id: id,
  //   url: url,
  //   name: name,
  //   status: status,
  //   title: title,
  //   stock: stock,
  //   productId: productId,
  //   sellingPrice: sellingPrice,
  //   sellingPoints: sellingPoints,
  //   placeOfOrigin: placeOfOrigin,
  //   description: description,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.updateRecordOfAdvertisementReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
