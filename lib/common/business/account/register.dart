import 'dart:typed_data';
import 'package:flutter_framework/common/route/account.dart';

import '../../../../utils/convert.dart';
import '../../route/major.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/account/register.dart';

void register({required String verificationCode, required String countryCode, required String phoneNumber}) {
  PacketClient packet = PacketClient.create();
  RegisterReq req = RegisterReq(verificationCode, countryCode, phoneNumber);
  packet.getHeader().setMajor(Major.account);
  packet.getHeader().setMinor(Account.registerReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
