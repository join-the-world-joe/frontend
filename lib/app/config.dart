class Config {
  static String scheme = 'ws';
  static String host = '127.0.0.1';
  static String port = '10001';
  static String url = 'ws://$host:$port/ws';
  // static String url = 'www.baidu.com';
  static const bool encryption = true;
  static Duration httpDefaultTimeout = const Duration(seconds: 10);
  static String aesKey = '3dd19414e91ac01b';
  static String aesIV = '2624b9a9c447e587';
  static const rsaPrivateKey = '';
  static const rsaPublicKey = '''-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDZsfv1qscqYdy4vY+P4e3cAtmv
ppXQcRvrF1cB4drkv0haU24Y7m5qYtT52Kr539RdbKKdLAM6s20lWy7+5C0Dgacd
wYWd/7PeCELyEipZJL07Vro7Ate8Bfjya+wltGK9+XNUIHiumUKULW4KDx21+1NL
AUeJ6PeW+DAkmJWF6QIDAQAB
-----END PUBLIC KEY-----''';
}
