
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

class AStep {
  String from = 'SignInProgress';
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  dynamic _rsp;

  AStep.construct() {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void skip() {
    _requested = true;
    _responded = true;
  }

  void respond(dynamic rsp) {
    _rsp = rsp;
    _responded = true;
  }

  bool timeout() {
    if (!_responded && DateTime.now().isAfter(_requestTime.add(_defaultTimeout))) {
      return true;
    }
    return false;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      _requestTime = DateTime.now();
      // business logic here
      _requested = true;
    }
    if (_requested) {
      if (timeout()) {
        return Code.internalError;
      }
      if (_responded) {
        if (_rsp != null) {
          if (_rsp!.getCode() == Code.oK) {
            return Code.oK;
          }
        }
        return Code.internalError;
      }
    }
    return Code.internalError * -1;
  }
}