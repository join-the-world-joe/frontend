class Config {
  static const contentAreaRefreshInterval = Duration(microseconds: 100);
  static String scheme = 'ws';
  static String host = '127.0.0.1';
  static String port = '10001';
  static String url = 'ws://$host:$port/ws';
  static bool debug = false;

  // static String url = 'www.baidu.com';
  static const bool encryption = true;
  static Duration httpDefaultTimeout = const Duration(seconds: 5);
  static String aesKey = '3dd19414e91ac01b';
  static String aesIV = '2624b9a9c447e587';
  static const rsaPrivateKey = '';
  static const checkStageIntervalNormal = Duration(milliseconds: 300);
  static const checkStageIntervalSmooth = Duration(milliseconds: 200);
  static const checkStageIntervalRealtime = Duration(milliseconds: 100);
  static const rsaPublicKey = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZsfv1qscqYdy4vY+P4e3cAtmv
ppXQcRvrF1cB4drkv0haU24Y7m5qYtT52Kr539RdbKKdLAM6s20lWy7+5C0Dgacd
wYWd/7PeCELyEipZJL07Vro7Ate8Bfjya+wltGK9+XNUIHiumUKULW4KDx21+1NL
AUeJ6PeW+DAkmJWF6QIDAQAB
-----END PUBLIC KEY-----''';

  static RegExp doubleRegExp = RegExp(r'^(\d+)?\.?\d?');
  static int lengthOfBuyingPrice = 11;
  static int lengthOfSellingPrice = 11;

  // screen
  static Duration periodOfScreenInitialisation = const Duration(milliseconds: 100);
  static Duration periodOfScreenNormal = const Duration(milliseconds: 500);
}
