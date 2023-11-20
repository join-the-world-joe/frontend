import 'package:flutter_framework/common/translator/chinese.dart';
import 'package:flutter_framework/common/translator/english.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/plugin/crypto/rsa.dart';
import 'package:flutter_framework/plugin/crypto/aes.dart';

void setup_() {
  // Runtime.encryption = Config.encryption;
  // Runtime.rsa = RSACrypto(publicKey: Config.rsaPublicKey, privateKey: Config.rsaPrivateKey);
  // Runtime.aes = AESCrypto(key: Config.aesKey, iv: Config.aesIV);

  Translator.setNative(Chinese.getName());
  // Translator.setNative(English.getName());

  try {
    Runtime.wsClient.setUrl(Config.url);
    Runtime.wsClient.connect();
    Runtime.wsClient.run();
  } catch (e) {
    print('_setup_ failure, e: $e');
  }
}
