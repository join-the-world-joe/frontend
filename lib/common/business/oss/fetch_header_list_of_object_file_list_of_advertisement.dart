import 'package:flutter_framework/common/route/oss.dart';
import '../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';

void fetchHeaderListOfObjectFileListOfAdvertisement({
  required String from,
  required String caller,
  required int advertisementId,
  required List<String> nameListOfFile,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.oss,
    minor: OSS.fetchHeaderListOfObjectFileListOfAdvertisementReq,
    body: FetchHeaderListOfObjectFileListOfAdvertisementReq.construct(
      advertisementId: advertisementId,
      nameListOfFile: nameListOfFile,
    ),
  );
}
