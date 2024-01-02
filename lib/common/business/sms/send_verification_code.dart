import 'package:flutter_framework/common/route/sms.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../../route/major.dart';
import 'package:flutter_framework/common/code/code.dart';
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
      behavior: behavior,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
    ),
  );
}

void sendVerificationCodeHandler({
  required String major,
  required String minor,
  required Map<String, dynamic> body,
}) {
  try {
    var rsp = SendVerificationCodeRsp.fromJson(body);
    if (rsp.getCode() == Code.oK) {
      return;
    } else{
      if (rsp.getCode() == Code.invalidDataType) {
        print(Translator.translate(Language.illegalPhoneNumber));
        return;
      } else {
        print('${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}');
        return;
      }
    }
  } catch(e){
    return;
  }
}


