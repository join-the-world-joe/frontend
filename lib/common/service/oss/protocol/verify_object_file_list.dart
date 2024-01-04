class VerifyObjectFileListReq {
  String _ossFolder = '';
  List<String> _nameListOfObjectFile = [];

  VerifyObjectFileListReq.construct({
    required String ossFolder,
    required List<String> nameListOfObjectFile,
  }) {
    _ossFolder = ossFolder;
    _nameListOfObjectFile = nameListOfObjectFile;
  }

  Map<String, dynamic> toJson() {
    return {
      "oss_folder": _ossFolder,
      "name_list_of_object_file": _nameListOfObjectFile,
    };
  }
}

class VerifyObjectFileListRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  VerifyObjectFileListRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
