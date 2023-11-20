import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/plugin/crypto/rsa.dart';
import 'package:flutter_framework/plugin/crypto/aes.dart';

void setup_() {
  Runtime.encryption = Config.encryption;
  Runtime.rsa = RSACrypto(publicKey: Config.rsaPublicKey, privateKey: Config.rsaPrivateKey);
  Runtime.aes = AESCrypto(key: Config.aesKey, iv: Config.aesIV);

  try {
    Runtime.wsClient.setUrl(Config.url);
    Runtime.wsClient.connect();
    Runtime.wsClient.run();
  } catch (e) {
    print('_setup_ failure, e: $e');
  }
}
