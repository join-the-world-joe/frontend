import 'dart:async';
import 'dart:convert';
import 'package:flutter_framework/common/route/route.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/framework/rate_limiter.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../plugin/crypto/rsa.dart';
import '../../../plugin/crypto/aes.dart';
import '../framework/packet_client.dart';
import '../framework/websocket.dart';
import '../../../common/code/code.dart';
import '../validator/packet_client.dart';

class Runtime {
  static RSACrypto rsa = RSACrypto(publicKey: Config.rsaPublicKey, privateKey: Config.rsaPrivateKey);
  static AESCrypto aes = AESCrypto(key: Config.aesKey, iv: Config.aesIV);
  static bool encryption = true;
  static bool _connected = true;
  static String token = '';
  static Function? _observe;
  static Function? _observer; // common observe for all pages
  static Duration period = Config.periodOfScreenNormal;
  static Function? _periodic;
  static Map<String, RateLimiter> _rateLimiter = {};
  static int defaultRateLimitDuration = 1000; // default, one seconds

  static bool allow({required int major, required int minor}) {
    var caller = 'allow';
    var key = '$major-$minor';
    if (!_rateLimiter.containsKey(key)) {
      Log.debug(
        major: major.toString(),
        minor: minor.toString(),
        from: 'Runtime',
        caller: caller,
        message: 'new rate limiter',
      );
      _rateLimiter[key] = RateLimiter(major, minor, defaultRateLimitDuration);
      return _rateLimiter[key]!.allow();
    }
    return _rateLimiter[key]!.allow();
  }

  static updateRateLimiter(Map<String, RateLimiter> any) {
    _rateLimiter = any;
  }

  static setConnectivity(bool b) {
    _connected = b;
  }

  static bool getConnectivity() {
    // print("connected: $_connected");
    return _connected;
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

  static setPeriodic(Function? periodic) {
    _periodic = periodic;
  }

  static getPeriodic() {
    return _periodic;
  }

  static setObserver(Function? callback) {
    _observer = callback;
  }

  static Function? getObserver() {
    return _observer;
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
            _observer?.call(packet);
          }
        } else {
          var packet = PacketClient.fromBytes(data);
          if (isPacketClientValid(packet) == Code.oK) {
            _observe?.call(packet);
          }
        }
      } catch (e) {
        print('wsClient.OnReceive.e: $e');
      } finally {}
    },
    onDone: () {
      print('Websocket.onDone');
      setConnectivity(false);
      wsClient.close();
    },
    onError: (err, StackTrace stackTrace) {
      print('onError.err: ${err.toString()}');
      if (err is WebSocketChannelException) {
        print('err == WebSocketChannelException');
        setConnectivity(false);
      }
    },
  );

  static periodic() {
    try {
      if (_periodic != null) {
        _periodic!.call();
      }
    } catch (e) {
      print('Runtime.periodic failure, err: $e');
    } finally {
      Timer(Runtime.period, periodic);
    }
  }

  static void setPeriod(Duration period) {
    Runtime.period = period;
  }

  static Duration getPeriod() {
    return Runtime.period;
  }

  static void request({
    required String from,
    required String caller,
    required dynamic body,
    required String major,
    required String minor,
  }) {
    try {
      if (!allow(major: int.parse(major), minor: int.parse(minor))) {
        var routingKey = Route.getKey(major: major, minor: minor);
        print('$from.$caller($routingKey:$major-$minor) Dropped');
        return;
      }
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'Requested',
      );
      PacketClient packet = PacketClient.create();
      packet.getHeader().setMajor(major);
      packet.getHeader().setMinor(minor);
      packet.setBody(body.toJson());
      Runtime.wsClient.sendPacket(packet);
    } catch (e) {
      print('Runtime.request failure, err: $e');
    }
  }
}
