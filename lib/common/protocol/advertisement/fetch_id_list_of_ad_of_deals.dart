import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchIdListOfADOfDealsReq {
  Map<String, dynamic> toJson() {
    return {};
  }
}

class FetchIdListOfADOfDealsRsp {
  int _code = Code.internalError;
  List<int> _advertisementIdList = [];
  int _versionOfADOfDeals = -1;

  int getCode() {
    return _code;
  }

  int getVersion() {
    return _versionOfADOfDeals;
  }

  List<int> getIdList() {
    return _advertisementIdList;
  }

  FetchIdListOfADOfDealsRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('version_of_ad_of_deals')) {
        _versionOfADOfDeals = body['version_of_ad_of_deals'];
      }
      if (body.containsKey('id_list_of_ad_of_deals')) {
        _advertisementIdList = List<int>.from(body['id_list_of_ad_of_deals'] as List);
      }
    }
  }
}
