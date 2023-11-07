import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchRoleListOfConditionReq {
  List<int> userIdList;
  String userName;
  String phoneNumber;

  FetchRoleListOfConditionReq(
      {required this.userIdList,
      required this.userName,
      required this.phoneNumber});

  Map<String, dynamic> toJson() => {
        'user_id_list': userIdList,
        'user_name': userName,
        'phone_number': phoneNumber,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchRoleListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchRoleListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchRoleListOfCondition({
  required List<int> userIdList,
  required String userName,
  required String phoneNumber,
}) {
  PacketClient packet = PacketClient.create();
  FetchRoleListOfConditionReq req = FetchRoleListOfConditionReq(
      userIdList: userIdList, userName: userName, phoneNumber: phoneNumber);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchRoleListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
