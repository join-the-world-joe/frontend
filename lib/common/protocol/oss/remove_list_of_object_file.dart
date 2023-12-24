class RemoveListOfObjectFileReq {
  List<String> _listOfObjectFile = [];

  RemoveListOfObjectFileReq.construct({required List<String> listOfObjectFile}) {
    _listOfObjectFile = listOfObjectFile;
  }

  Map<String, dynamic> toJson() {
    return {
      "list_of_object_file": _listOfObjectFile,
    };
  }
}

class RemoveListOfObjectFileRsp {
  int _code = -1;
  List<String> _listOfObjectFile = [];

  int getCode() {
    return _code;
  }

  List<String> getListOfObjectFile() {
    return _listOfObjectFile;
  }

  RemoveListOfObjectFileRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('list_of_object_file')) {
        for (var e in body['list_of_object_file']) {
          _listOfObjectFile.add(e);
        }
      }
    }
  }
}
