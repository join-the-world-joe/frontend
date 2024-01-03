import 'dart:typed_data';
import '../../../../../utils/convert.dart';

class Behavior {
  static const String login = 'Login';
  static const String signIn = 'SignIn';
  static const String register = 'Register';
}

class SendVerificationCodeReq {
  String _behavior = '';
  String _countryCode = '';
  String _phoneNumber = '';

  SendVerificationCodeReq({
    required String behavior,
    required String countryCode,
    required String phoneNumber,
  }) {
    _behavior = behavior;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
  }

  Map<String, dynamic> toJson() => {
        'behavior': _behavior,
        'country_code': _countryCode,
        'phone_number': _phoneNumber,
      };
}

class SendVerificationCodeRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  Map<String, dynamic> toJson() => {
        "code": _code,
      };

  SendVerificationCodeRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
