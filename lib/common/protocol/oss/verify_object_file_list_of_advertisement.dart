/*
type VerifyObjectFileListOfAdvertisementReq struct {
	UserId               int64
	AdvertisementId      int64    `json:"advertisement_id"`
	NameListOfObjectFile []string `json:"name_list_of_object_file"`
}

type VerifyObjectFileListOfAdvertisementRsp struct {
	Code int             `json:"code"`
	Body json.RawMessage `json:"body"`
}

 */

class VerifyObjectFileListOfAdvertisementReq {
  int _advertisementId = -1;
  List<String> _nameListOfObjectFile = [];

  VerifyObjectFileListOfAdvertisementReq.construct({
    required int advertisementId,
    required List<String> nameListOfObjectFile,
  }) {
    _advertisementId = advertisementId;
    _nameListOfObjectFile = nameListOfObjectFile;
  }

  Map<String, dynamic> toJson() {
    return {
      "advertisement_id": _advertisementId,
      "name_list_of_object_file": _nameListOfObjectFile,
    };
  }
}

class VerifyObjectFileListOfAdvertisementRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  VerifyObjectFileListOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
