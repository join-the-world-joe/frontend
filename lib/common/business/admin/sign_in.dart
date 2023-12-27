import 'dart:html';
import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/sign_in.dart';

void signIn({
  required String from,
  required String caller,
  required String email,
  required String memberId,
  required String account,
  required int behavior,
  required Uint8List password,
  required String phoneNumber,
  required String countryCode,
  required int verificationCode,
  required int userId,
}) {
  Runtime.request(
    from: from,
    caller: caller,
    major: Major.admin,
    minor: Admin.signInReq,
    body: SignInReq.construct(
      email: email,
      memberId: memberId,
      account: account,
      behavior: behavior,
      password: password,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      verificationCode: verificationCode,
      userId: userId,
    ),
  );
}

void signInHandler({required String major, required String minor, required Map<String, dynamic> body}) {
  try {
    var rsp = SignInRsp.fromJson(body);
    if (rsp.getCode() == Code.oK) {
    } else {
      // error occurs
      return;
    }
  } catch (e) {
    return;
  }
}
