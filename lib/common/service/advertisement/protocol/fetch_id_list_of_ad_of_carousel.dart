import 'package:flutter_framework/common/code/code.dart';

class FetchIdListOfADOfCarouselReq {
  int _behavior = -1;

  Map<String, dynamic> toJson() {
    return {"behavior": _behavior};
  }

  FetchIdListOfADOfCarouselReq.construct({required int behavior}) {
    _behavior = behavior;
  }
}

class FetchIdListOfADOfCarouselRsp {
  int _code = Code.internalError;
  List<int> _advertisementIdList = [];
  int _versionOfADOfCarousel = -1;

  int getCode() {
    return _code;
  }

  int getVersion() {
    return _versionOfADOfCarousel;
  }

  List<int> getIdList() {
    return _advertisementIdList;
  }

  FetchIdListOfADOfCarouselRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('version_of_ad_of_carousel')) {
        _versionOfADOfCarousel = body['version_of_ad_of_carousel'];
      }
      if (body.containsKey('id_list_of_ad_of_carousel')) {
        _advertisementIdList = List<int>.from(body['id_list_of_ad_of_carousel'] as List);
      }
    }
  }
}
