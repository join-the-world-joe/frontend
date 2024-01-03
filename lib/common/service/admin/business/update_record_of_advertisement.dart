import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_record_of_advertisement.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void updateRecordOfAdvertisement({
  required String from,
  required String caller,
  required int id,
  required String coverImage,
  required String firstImage,
  required String secondImage,
  required String thirdImage,
  required String fourthImage,
  required String fifthImage,
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
      coverImage: coverImage,
      firstImage: firstImage,
      secondImage: secondImage,
      thirdImage: thirdImage,
      fourthImage: fourthImage,
      fifthImage: fifthImage,
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
