class InsertRecordOfADOfDealsReq {
  List<int> _advertisementIdList = [];

  InsertRecordOfADOfDealsReq.construct({
    required List<int> advertisementIdList,
  }) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisement_id_list': _advertisementIdList,
    };
  }
}

class InsertRecordOfADOfDealsRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  InsertRecordOfADOfDealsRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
