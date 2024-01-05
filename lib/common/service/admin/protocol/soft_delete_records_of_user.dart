class SoftDeleteRecordsOfUserReq {
  List<int> _userIdList = [];

  SoftDeleteRecordsOfUserReq.construct({
    required List<int> userIdList,
  }) {
    _userIdList = userIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id_list': _userIdList,
    };
  }
}

class SoftDeleteRecordsOfUserRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  SoftDeleteRecordsOfUserRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
