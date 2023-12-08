import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class UpdateUserRecordReq {
  String _name = '';
  int _userId = -1;
  int _status = 0;
  Uint8List _password = Uint8List.fromList([]);
  String _countryCode = '';
  String _phoneNumber = '';
  List<String> _roleList = [];

  UpdateUserRecordReq.construct({
    required String name,
    required int userId,
    required int status,
    required Uint8List password,
    required String countryCode,
    required String phoneNumber,
    required List<String> roleList,
  }) {
    _name = name;
    _userId = userId;
    _status = status;
    _password = password;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _roleList = roleList;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'user_id': _userId,
      'phone_number': _phoneNumber,
      'country_code': _countryCode,
      'status': _status,
      'password': _password,
      'role_list': _roleList,
    };
  }
}

class UpdateUserRecordRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  UpdateUserRecordRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}

void updateUserRecord({
  required String name,
  required int userId,
  required String phoneNumber,
  required String countryCode,
  required int status,
  required Uint8List password,
  required List<String> roleList,
}) {
  PacketClient packet = PacketClient.create();
  UpdateUserRecordReq req = UpdateUserRecordReq.construct(
    userId: userId,
    name: name,
    phoneNumber: phoneNumber,
    countryCode: countryCode,
    status: status,
    password: password,
    roleList: roleList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.updateUserRecordReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
