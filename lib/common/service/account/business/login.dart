import 'dart:typed_data';
import 'package:flutter_framework/common/route/account.dart';

import '../../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../../route/major.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/account/protocol/login.dart';

void login({
  required String from,
  required String caller,
  required String verificationCode,
  required String countryCode,
  required String phoneNumber,
  required String token,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.account,
    minor: Account.loginReq,
    body: LoginReq.construct(
      token: token,
      verificationCode: verificationCode,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
    ),
  );
  //
  // PacketClient packet = PacketClient.create();
  // LoginReq req = LoginReq.construct(
  //   token: token,
  //   verificationCode: verificationCode,
  //   phoneNumber: phoneNumber,
  //   countryCode: countryCode,
  // );
  // packet.getHeader().setMajor(Major.account);
  // packet.getHeader().setMinor(Account.loginReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
