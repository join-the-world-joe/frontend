
class SoftDeleteUserRecordReq {
  List<int> _userIdList = [];

  SoftDeleteUserRecordReq.construct({
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

class SoftDeleteUserRecordRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  SoftDeleteUserRecordRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
