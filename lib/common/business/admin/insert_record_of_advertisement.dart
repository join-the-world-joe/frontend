import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_advertisement.dart';

void insertRecordOfAdvertisement({
  required String from,
  required String caller,
  required String name,
  required String title,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String image,
  required String placeOfOrigin,
  required int stock,
  required int productId,
  required String thumbnail,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.insertRecordOfAdvertisementReq,
    body: InsertRecordOfAdvertisementReq.construct(
      name: name,
      title: title,
      sellingPrice: sellingPrice,
      sellingPoints: sellingPoints,
      placeOfOrigin: placeOfOrigin,
      image: image,
      stock: stock,
      productId: productId,
      thumbnail: thumbnail,
    ),
  );
}
