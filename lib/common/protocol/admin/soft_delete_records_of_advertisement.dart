
class SoftDeleteRecordsOfAdvertisementReq {
  List<int> _advertisementIdList = [];

  SoftDeleteRecordsOfAdvertisementReq.construct({required List<int> advertisementIdList}) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisement_id_list': _advertisementIdList,
    };
  }
}

class SoftDeleteRecordsOfAdvertisementRsp {
  int code = -1;

  SoftDeleteRecordsOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}
