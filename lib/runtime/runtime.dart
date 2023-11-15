import 'dart:async';
import 'dart:convert';
import 'package:flutter_framework/framework/rate_limiter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../plugin/crypto/rsa.dart';
import '../../../plugin/crypto/aes.dart';
import '../framework/packet_client.dart';
import '../framework/websocket.dart';
import '../../../common/code/code.dart';
import '../validator/packet_client.dart';

class Runtime {
  static late RSACrypto rsa;
  static late AESCrypto aes;
  static late bool encryption;
  static bool connected = false;
  static late String token;
  static Function? _observe;
  static Map<String, RateLimiter> _rateLimiter = {};

  static bool allow({required int major, required int minor}) {
    var key = '$major-$minor';
    if (!_rateLimiter.containsKey(key)) {
      _rateLimiter[key] = RateLimiter(major, minor, 1000); // default, one seconds
      return _rateLimiter[key]!.allow();
    }
    return _rateLimiter[key]!.allow();
  }

  static updateRateLimiter(Map<String, RateLimiter> any) {
    _rateLimiter = any;
  }

  static setConnectivity(bool b) {
    connected = b;
  }

  static bool getConnectivity() {
    return connected;
  }

  static setToken(String any) {
    token = any;
  }

  static String getToken() {
    return token;
  }

  static setObserve(Function? callback) {
    _observe = callback;
  }

  static Function? getObserve() {
    return _observe;
  }

  static Websocket wsClient = Websocket(
    encryption: encryption,
    aes: aes,
    onReceive: (data) {
      try {
        if (encryption) {
          var packet = PacketClient.fromJson(jsonDecode(aes.Decrypt(data)));
          if (isPacketClientValid(packet) == Code.oK) {
            _observe?.call(packet);
          }
          return;
        } else {
          var packet = PacketClient.fromBytes(data);
          if (isPacketClientValid(packet) == Code.oK) {
            _observe?.call(packet);
          }
          return;
        }
      } catch (e) {
        print('wsClient.OnReceive.e: $e');
        return;
      }
    },
    onDone: () {
      setConnectivity(false);
      print('onDone');
    },
    onError: (err, StackTrace stackTrace) {
      print('onError.err: ${err.toString()}');
      // if (err is WebSocketChannelException) {
      //   print('err == WebSocketChannelException');
      //   setConnectivity(false);
      // }
    },
  );
}
