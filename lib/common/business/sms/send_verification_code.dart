import 'dart:typed_data';
import 'package:flutter_framework/common/route/sms.dart';

import '../../../../utils/convert.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/sms/send_verification_code.dart';

void sendVerificationCode({
  required String from,
  required String caller,
  required String behavior,
  required String countryCode,
  required String phoneNumber,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.sms,
    minor: SMS.sendVerificationCodeReq,
    body: SendVerificationCodeReq(
      behavior,
      countryCode,
      phoneNumber,
    ),
  );
  //
  // PacketClient packet = PacketClient.create();
  // SendVerificationCodeReq req = SendVerificationCodeReq(behavior, countryCode, phoneNumber);
  // packet.getHeader().setMajor(Major.sms);
  // packet.getHeader().setMinor(SMS.sendVerificationCodeReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
