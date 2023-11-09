import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../plugin/crypto/rsa.dart';
import '../../../plugin/crypto/aes.dart';
import '../framework/packet_client.dart';
import '../framework/websocket.dart';
import '../../../utils/convert.dart';
import '../../../common/code/code.dart';
import '../validator/packet_client.dart';

class Runtime {
  static late RSACrypto rsa;
  static late AESCrypto aes;
  static late bool encryption;
  static bool connected = false;
  static late String token;
  static Function? _observe;

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
        var packet = PacketClient.fromBytes(
          encryption ? Convert.toBytes(aes.Decrypt(data)) : data,
        );
        if (isPacketClientValid(packet) == Code.oK) {
          _observe?.call(packet);
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
