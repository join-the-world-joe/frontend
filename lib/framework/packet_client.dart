import 'dart:convert';
import 'dart:typed_data';
import 'header.dart';
import '../../../utils/convert.dart';

class PacketClient {
  Header _header = Header();
  Map<String, dynamic> _body = {};

  static final PacketClient _instance = PacketClient.create();

  PacketClient.create() {
    _header = Header();
    _body = {};
  }

  factory PacketClient.build() => _instance;

  PacketClient({required Header header, required Map<String, dynamic> body}) {
    _header = header;
    _body = body;
  }

  void setHeader({required Header header}) {
    _header = header;
  }

  Header getHeader() {
    return _header;
  }

  void setBody(Map<String, dynamic> body) {
    _body = body;
  }

  Map<String, dynamic> getBody() {
    return _body;
  }

  Map<String, dynamic> toJson() => {
        "header": _header.toJson(),
        "body": _body,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.Bytes2String(Convert.toBytes(this));
  }

  static PacketClient fromBytes(Uint8List list) {
    try {
      return PacketClient.fromJson(jsonDecode(Convert.Bytes2String(list)));
    } catch (e) {
      // print('PacketClient.fromBytes.e: $e');
      return _instance;
    }
  }

  // 不能直接调用，没有捕获异常
  factory PacketClient.fromJson(Map<String, dynamic> json) => PacketClient(
        header: Header.build(
          major: json['header']['major'],
          minor: json['header']['minor'],
        ),
        body: json['body'],
      );
}
