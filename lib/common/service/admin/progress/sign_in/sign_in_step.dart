import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/sign_in.dart';
import 'package:flutter_framework/common/service/admin/protocol/sign_in.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

class SignInStep {
  String from = 'SignInProgress';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  int _behavior = -1;
  int _userId = -1;
  int _verificationCode = -1;
  String _countCode = '';
  String _phoneNumber = '';
  String _account = '';
  String _memberId = '';
  SignInRsp? _rsp;
  Uint8List _password = Uint8List(0);
  String _email = '';

  SignInStep.construct() {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void respond(SignInRsp rsp) {
    if (rsp.getCode() == Code.oK) {
      Cache.setUserId(rsp.getUserId());
      Cache.setMemberId(rsp.getMemberId());
      Cache.setSecret(rsp.getSecret());
    }
    _rsp = rsp;
    _responded = true;
  }

  bool timeout() {
    if (!_responded && DateTime.now().isAfter(_requestTime.add(_defaultTimeout))) {
      return true;
    }
    return false;
  }

  void setUserId(int userId) {
    _userId = userId;
  }

  void setPassword(Uint8List password) {
    _password = password;
  }

  void setVerificationCode(int verificationCode) {
    _verificationCode = verificationCode;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setCountryCode(String countryCode) {
    _countCode = countryCode;
  }

  void setBehavior(int behavior) {
    _behavior = behavior;
  }

  void setAccount(String account) {
    _account = account;
  }

  void setMemberId(String memberId) {
    _memberId = memberId;
  }

  void setEmail(String email) {
    _email = email;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      _requestTime = DateTime.now();
      signIn(
        from: from,
        caller: caller,
        behavior: _behavior,
        verificationCode: _verificationCode,
        countryCode: _countCode,
        phoneNumber: _phoneNumber,
        email: _email,
        account: _account,
        memberId: _memberId,
        password: _password,
        userId: _userId,
      );
      _requested = true;
    }
    if (_requested) {
      if (timeout()) {
        return Code.internalError;
      }
      if (_responded) {
        if (_rsp != null) {
          if (_rsp!.getCode() == Code.oK) {
            // print('ok');
            return Code.oK;
          }
        }
        return Code.internalError;
      }
    }
    return Code.internalError * -1;
  }
}
