import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';
import '../../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void fetchHeaderListOfObjectFileList({
  required String from,
  required String caller,
  required List<String> nameListOfFile,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.oss,
    minor: OSS.fetchHeaderListOfObjectFileListOfAdvertisementReq,
    body: FetchHeaderListOfObjectFileListReq.construct(
      nameListOfFile: nameListOfFile,
    ),
  );
}
