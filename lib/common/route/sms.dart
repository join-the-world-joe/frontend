class SMS {
  static const String sendVerificationCodeReq = '1';
  static const String sendVerificationCodeRsp = '2';

  String getName({required String minor}) {
    switch (minor) {
      case sendVerificationCodeReq:
        return 'sendVerificationCodeReq';
      case sendVerificationCodeRsp:
        return 'sendVerificationCodeRsp';
      default:
        return 'unknown';
    }
  }
}
