import 'package:flutter_framework/common/protocol/oss/remove_list_of_object_file.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/runtime/runtime.dart';

void removeListOfObjectFile({
  required String from,
  required String caller,
  required List<String> listOfObjectFile,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.oss,
    minor: OSS.removeListOfObjectFileReq,
    body: RemoveListOfObjectFileReq.construct(
      listOfObjectFile: listOfObjectFile,
    ),
  );
}
