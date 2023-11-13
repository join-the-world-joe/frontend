import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class UpdateUserRecordReq {
  final String _name;
  final int _userId;
  final int _status;
  final Uint8List _password;
  final String _countryCode;
  final String _phoneNumber;
  final List<String> _roleList;

  UpdateUserRecordReq(this._userId, this._name, this._phoneNumber, this._countryCode, this._status, this._password, this._roleList);

  Map<String, dynamic> toJson() => {
        'name': utf8.encode(_name),
        'user_id': _userId,
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

class UpdateUserRecordRsp {
  late int code;

  UpdateUserRecordRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
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
  UpdateUserRecordReq req = UpdateUserRecordReq(
    userId,
    name,
    phoneNumber,
    countryCode,
    status,
    password,
    roleList,
  );
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.updateUserRecordReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
