import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class InsertUserRecordReq {
  String _name = '';
  String _phoneNumber = '';
  String _countryCode = '';
  int _status = 0;
  Uint8List _password = Uint8List.fromList([]);
  List<String> _roleList = [];

  InsertUserRecordReq.construct({
    required String name,
    required String phoneNumber,
    required String countryCode,
    required int status,
    required Uint8List password,
    required List<String> roleList,
  }) {
    _name = name;
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;
    _status = status;
    _password = password;
    _roleList = roleList;
  }

  // InsertUserRecordReq(this._name, this._phoneNumber, this._countryCode, this._status, this._password, this._roleList);

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
    if (json.containsKey('code')) {
      code = json['code'];
    }
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
  InsertUserRecordReq req = InsertUserRecordReq.construct(
    name: name,
    phoneNumber: phoneNumber,
    countryCode: countryCode,
    status: status,
    password: password,
    roleList: roleList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.insertUserRecordReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
