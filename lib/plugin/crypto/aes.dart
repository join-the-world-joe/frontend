import 'package:encrypt/encrypt.dart';
import 'dart:typed_data';
import 'package:flutter_framework/abstract/crypto.dart';

class AESCrypto extends Crypto {
  Key? _key;
  IV? _iv;

  AESCrypto({required String key, required String iv}) {
    _key = Key.fromUtf8(key);
    _iv = IV.fromUtf8(iv);
  }

  @override
  String Name() {
    return 'AES Encryption';
  }

  @override
  Uint8List Encrypt(String plainText) {
    // note: AES不限制明文长度，得限制密钥长度，只支持 128，192，256 此三种
    final encrypter = Encrypter(
      AES(_key!, mode: AESMode.cbc, padding: 'PKCS7'),
    );

    return encrypter.encrypt(plainText, iv: _iv).bytes;
  }

  @override
  String Decrypt(Uint8List cipherText) {
    final encrypter =
        Encrypter(AES(_key!, mode: AESMode.cbc, padding: 'PKCS7'));

    return encrypter.decrypt(Encrypted(cipherText), iv: _iv);
  }
}
