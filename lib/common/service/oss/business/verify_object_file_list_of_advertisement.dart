import 'dart:typed_data';
import 'package:flutter_framework/common/service/oss/protocol/verify_object_file_list_of_advertisement.dart';
import 'package:flutter_framework/common/route/oss.dart';
import '../../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void verifyObjectFileListOfAdvertisement({
  required String from,
  required String caller,
  required int advertisementId,
  required List<String> nameListOfObjectFile,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.oss,
    minor: OSS.verifyObjectFileListOfAdvertisementReq,
    body: VerifyObjectFileListOfAdvertisementReq.construct(
      advertisementId: advertisementId,
      nameListOfObjectFile: nameListOfObjectFile,
    ),
  );
}
