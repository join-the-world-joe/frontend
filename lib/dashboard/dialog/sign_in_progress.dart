import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/progress/sign_in_progress.dart';
import 'package:flutter_framework/common/protocol/admin/sign_in.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';

class SignInProgressDialog {
  SignInProgress? step;
  double width = 220;
  double height = 150;
  String _email = '';
  int _result = -1;
  String _memberId = '';
  String _account = '';
  String _phoneNumber = '';
  String _countryCode = '';
  int _verificationCode = -1;
  int _userId = -1;
  int _behavior = -1;
  Uint8List _password = Uint8List(0);

  void setPassword(Uint8List password) {
    _password = password;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setCountryCode(String countryCode) {
    _countryCode = countryCode;
  }

  void setBehavior(int behavior) {
    _behavior = behavior;
  }

  void setUserId(int userId) {
    _userId = userId;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setMemberId(String memberId) {
    _memberId = memberId;
  }

  void setAccount(String account) {
    _account = account;
  }

  void setVerificationCode(int verificationCode) {
    _verificationCode = verificationCode;
  }

  void respond(SignInRsp rsp) {
    if (step != null) {
      step!.respond(rsp);
    }
  }

  SignInProgressDialog.construct({
    required int result,
  }) {
    _result = result;
  }

  Future<int> show({
    required BuildContext context,
  }) async {
    bool closed = false;
    int curStage = 0;
    String information = '';

    bool hasFigureOutStepArgument = false;

    Stream<int>? stream() async* {
      var lastStage = curStage;
      while (!closed) {
        await Future.delayed(Config.checkStageIntervalNormal);
        if (lastStage != curStage) {
          lastStage = curStage;
          yield lastStage;
        }
      }
    }

    void progress() {
      if (!hasFigureOutStepArgument) {
        step!.setEmail(_email);
        step!.setUserId(_userId);
        step!.setAccount(_account);
        step!.setPassword(_password);
        step!.setBehavior(_behavior);
        step!.setMemberId(_memberId);
        step!.setCountryCode(_countryCode);
        step!.setPhoneNumber(_phoneNumber);
        step!.setVerificationCode(_verificationCode);
        hasFigureOutStepArgument = true;
      }

      var ret = step!.progress();
      if (ret < 0) {
        Navigator.pop(context);
        return;
      }
      if (ret == Code.oK) {
        _result = Code.oK;
        Navigator.pop(context);
        return;
      }

      return;
    }

    void setup() {
      step = SignInProgress.construct();
      Runtime.setPeriod(Config.periodOfScreenInitialisation);
      Runtime.setPeriodic(progress);
    }

    setup();

    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translator.translate(Language.signIn)),
          actions: [],
          content: StreamBuilder(
            stream: stream(),
            builder: (context, snap) {
              return SizedBox(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(information),
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                      Spacing.addVerticalSpace(10),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).then(
      (value) {
        closed = true;
        Runtime.setPeriod(Config.periodOfScreenNormal);
        Runtime.setPeriodic(null);
        return _result;
      },
    );
  }
}
