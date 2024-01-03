import 'package:flutter_framework/framework/rate_limiter.dart';

class FetchRateLimitingConfigReq {
  Map<String, dynamic> toJson() {
    return {};
  }
}

class FetchRateLimitingConfigRsp {
  int _code = -1;
  Map<String, RateLimiter> _rateLimiter = {};

  int getCode() {
    return _code;
  }

  Map<String, RateLimiter> getRateLimiter() {
    return _rateLimiter;
  }

  FetchRateLimitingConfigRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    _rateLimiter = {};
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('rate_limit_list')) {
        Map<String, dynamic> any = body['rate_limit_list'];
        any.forEach(
              (key, value) {
            _rateLimiter['${value['major']}-${value['minor']}'] = RateLimiter(value['major'], value['minor'], value['period']);
          },
        );
      }
    }
  }
}
