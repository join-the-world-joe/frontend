class InsertRecordOfADOfCarouselReq {
  List<int> _advertisementIdList = [];

  InsertRecordOfADOfCarouselReq.construct({
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

class InsertRecordOfADOfCarouselRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  InsertRecordOfADOfCarouselRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
