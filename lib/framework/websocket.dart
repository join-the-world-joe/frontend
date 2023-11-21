import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../plugin/crypto/aes.dart';
import 'packet_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_framework/common/code/code.dart';

class Websocket {
  String _url = '';
  bool _encryption = false;
  AESCrypto? _aes;
  WebSocketChannel? _channel;

  Function? _onError;
  VoidCallback? _onDone;
  Function(dynamic)? _onReceive;

  Websocket({
    required bool encryption,
    required AESCrypto aes,
    required Function(dynamic) onReceive,
    required VoidCallback onDone,
    required Function onError,
  }) {
    _aes = aes;
    _encryption = encryption;
    _onReceive = onReceive;
    _onDone = onDone;
    _onError = onError;
  }

  String name() {
    return 'Websocket Client';
  }

  Future<String> connect() async {
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(_url),
      );
    }catch(e) {
     print('Websocket.connect fail: $e');
    }
    return '';
  }

  Future<String> sendPacket(PacketClient packet) async {
    var list = Uint8List(0);
    try {
      // print('sendPacket: ${packet.toString()}');
      if (_encryption) {
        list = _aes!.Encrypt(packet.toString());
      } else {
        list = packet.toBytes();
      }
      return await send(list);
    } catch (e) {
      return 'WebsocketClientPlugin.sendPacket.e: ($e)';
    }
  }

  Future<String> send(Uint8List list) async {
    try {
      if (list.isNotEmpty) {
        _channel?.sink.add(list);
        return 'ok';
      }
      return 'not ok, list is empty';
    } catch (e) {
      return 'send.e: ($e)';
    }
  }

  Future<void> run() async {
    try {
      _channel?.stream.listen(_onReceive, onDone: _onDone, onError: _onError, cancelOnError: false);
    } catch (e) {
      print('Websocket.run failure, err: $e');
    }
  }

  void close() {
    print('Websocket.close');
    if (_channel != null) {
      _channel!.sink.close();
    }
  }

  setUrl(String url) {
    _url = url;
  }

  String getUrl() {
    return _url;
  }

  void setOnReceive(Function(dynamic) onReceive) {
    _onReceive = onReceive;
  }

  void setOnError(Function? onError) {
    _onError = onError;
  }

  void setOnDone(VoidCallback? onDone) {
    _onDone = onDone;
  }
}
