class Account {
  static const String loginReq = '1';
  static const String loginRsp = '2';
  static const String logoutReq = '3';
  static const String logoutRsp = '4';
  static const String registerReq = '5';
  static const String registerRsp = '6';

  String getName({required String minor}) {
    switch (minor) {
      case loginReq:
        return 'loginReq';
      case loginRsp:
        return 'loginRsp';
      case logoutReq:
        return 'logoutReq';
      case logoutRsp:
        return 'logoutRsp';
      case registerReq:
        return 'registerReq';
      case registerRsp:
        return 'registerRsp';
      default:
        return 'unknown';
    }
  }
}
