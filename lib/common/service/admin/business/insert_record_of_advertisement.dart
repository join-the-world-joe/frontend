import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/insert_record_of_advertisement.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void insertRecordOfAdvertisement({
  required String from,
  required String caller,
  required String name,
  required String title,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String coverImage,
  required String firstImage,
  required String secondImage,
  required String thirdImage,
  required String fourthImage,
  required String fifthImage,
  required String placeOfOrigin,
  required int stock,
  required int productId,
  required String ossPath,
  required String ossFolder,
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
      coverImage: coverImage,
      firstImage: firstImage,
      secondImage: secondImage,
      thirdImage: thirdImage,
      fourthImage: fourthImage,
      fifthImage: fifthImage,
      stock: stock,
      productId: productId,
      ossPath: ossPath,
      ossFolder: ossFolder,
    ),
  );
}
