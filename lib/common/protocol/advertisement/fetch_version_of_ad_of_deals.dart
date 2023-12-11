import 'package:flutter_framework/common/code/code.dart';

class FetchVersionOfADOfDealsReq {
  Map<String, dynamic> toJson() {
    return {};
  }
}

class FetchVersionOfADOfDealsRsp {
  int _code = Code.internalError;
  int _versionOfADOfDeals = -1;

  int getCode() {
    return _code;
  }

  int getVersion() {
    return _versionOfADOfDeals;
  }

  FetchVersionOfADOfDealsRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('version_of_ad_of_deals')) {
        _versionOfADOfDeals = body['version_of_ad_of_deals'];
      }
    }
  }
}
