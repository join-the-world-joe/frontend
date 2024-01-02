class Major {
  static const String generic = "0";
  static const String frontendGateway = "1";
  static const String backendGateway = "2";
  static const String account = "3";
  static const String sms = "4";
  static const String admin = '5';
  static const String inform = '6';
  static const String advertisement = '7';
  static const String oss = '8';
  static const String product = '9';

  static String getName({required String major}) {
    switch (major) {
      case generic:
        return 'generic';
      case frontendGateway:
        return 'frontendGateway';
      case backendGateway:
        return 'backendGateway';
      case account:
        return 'account';
      case sms:
        return 'sms';
      case admin:
        return 'admin';
      case inform:
        return 'inform';
      case advertisement:
        return 'advertisement';
      case oss:
        return 'oss';
      case product:
        return 'product';
      default:
        return 'unknown';
    }
  }
}
