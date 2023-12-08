import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchPermissionListOfConditionReq {
  String _name = ''; // the name of permission
  String _major = '';
  String _minor = '';
  int _userId = -1;
  int _behavior = -1;
  RoleList _roleList = RoleList([]);

  FetchPermissionListOfConditionReq.construct({
    required String name,
    required String major,
    required String minor,
    required int userId,
    required int behavior,
    required RoleList roleList,
  }) {
    _name = name;
    _major = major;
    _minor = minor;
    _userId = userId;
    _behavior = behavior;
    _roleList = roleList;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'major': _major,
      'minor': _minor,
      'user_id': _userId,
      'behavior': _behavior,
      'role_list': _roleList.getNameList(),
    };
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchPermissionListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchPermissionListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}

void fetchPermissionListOfCondition({
  required String name,
  required String major,
  required String minor,
  required int userId,
  required int behavior,
  required RoleList roleList,
}) {
  PacketClient packet = PacketClient.create();
  FetchPermissionListOfConditionReq req = FetchPermissionListOfConditionReq.construct(
    name: name,
    major: major,
    minor: minor,
    userId: userId,
    behavior: behavior,
    roleList: roleList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchPermissionListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
