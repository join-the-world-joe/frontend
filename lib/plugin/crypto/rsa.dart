import 'package:flutter_framework/abstract/crypto.dart';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSACrypto extends Crypto {
  String _publicKey = '';
  String _privateKey = '';

  RSACrypto({required String publicKey, required String privateKey}) {
    _publicKey = publicKey;
    _privateKey = privateKey;
  }

  @override
  String name() {
    return 'RSA Encryption';
  }

  @override
  Uint8List encrypt(String plainText) {
    // @note RSA加密时，有最大长度限制，字符串最长为117个字节，超出限制会报错
    RSAPublicKey public = RSAKeyParser().parse(_publicKey) as RSAPublicKey;
    return Encrypter(RSA(publicKey: public)).encrypt(plainText).bytes;
  }

  @override
  String decrypt(Uint8List cipherText) {
    RSAPrivateKey private = RSAKeyParser().parse(_privateKey) as RSAPrivateKey;
    return Encrypter(RSA(privateKey: private)).decrypt(Encrypted(cipherText));
  }
}
