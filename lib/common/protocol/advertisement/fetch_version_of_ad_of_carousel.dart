import 'package:flutter_framework/common/code/code.dart';

class FetchVersionOfADOfCarouselReq {
  Map<String, dynamic> toJson() {
    return {};
  }
}

class FetchVersionOfADOfCarouselRsp {
  int _code = Code.internalError;
  int _versionOfADOfCarousel = -1;

  int getCode() {
    return _code;
  }

  int getVersion() {
    return _versionOfADOfCarousel;
  }

  FetchVersionOfADOfCarouselRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('version_of_ad_of_carousel')) {
        _versionOfADOfCarousel = body['version_of_ad_of_carousel'];
      }
    }
  }
}
