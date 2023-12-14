class BackendGateway {
  static const String fetchRateLimitingConfigReq = "1";
  static const String fetchRateLimitingConfigRsp = "2";
  static const String pingReq = '3';
  static const String pongRsp = '4';

  String getName({required String minor}) {
    switch (minor) {
      case fetchRateLimitingConfigReq:
        return 'fetchRateLimitingConfigReq';
      case fetchRateLimitingConfigRsp:
        return 'fetchRateLimitingConfigRsp';
      case pingReq:
        return 'pingReq';
      case pongRsp:
        return 'pongRsp';
      default:
        return 'unknown';
    }
  }
}
