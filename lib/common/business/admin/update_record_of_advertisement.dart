import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_advertisement.dart';

void updateRecordOfAdvertisement({
  required String from,
  required String caller,
  required int id,
  required String image,
  required String name,
  required String title,
  required int stock,
  required int status,
  required int productId,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String placeOfOrigin,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.updateRecordOfAdvertisementReq,
    body: UpdateRecordOfAdvertisementReq.construct(
      id: id,
      image: image,
      name: name,
      title: title,
      stock: stock,
      status: status,
      productId: productId,
      sellingPrice: sellingPrice,
      sellingPoints: sellingPoints,
      placeOfOrigin: placeOfOrigin,
    ),
  );
}
