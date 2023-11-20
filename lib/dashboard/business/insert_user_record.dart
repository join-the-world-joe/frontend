import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class InsertUserRecordReq {
  final String _name;
  final String _phoneNumber;
  final String _countryCode;
  final int _status;
  final Uint8List _password;
  final List<String> _roleList;

  InsertUserRecordReq(this._name, this._phoneNumber, this._countryCode, this._status, this._password, this._roleList);

  Map<String, dynamic> toJson() => {
        'name': utf8.encode(_name),
        'phone_number': _phoneNumber,
        'country_code': _countryCode,
        'status': _status,
        'password': _password,
        'role_list': _roleList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class InsertUserRecordRsp {
  late int code;

  InsertUserRecordRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void insertUserRecord({
  required String name,
  required String phoneNumber,
  required String countryCode,
  required int status,
  required Uint8List password,
  required List<String> roleList,
}) {
  PacketClient packet = PacketClient.create();
  InsertUserRecordReq req = InsertUserRecordReq(
    name,
    phoneNumber,
    countryCode,
    status,
    password,
    roleList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.insertUserRecordReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
