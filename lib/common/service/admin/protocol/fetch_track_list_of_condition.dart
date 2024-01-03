import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchTrackListOfConditionReq {
  String _operator = '';
  int _behavior = 0;
  int _begin = 0;
  int _end = 0;
  String _major = '';
  String _minor = '';

  FetchTrackListOfConditionReq.construct({
    required String operator,
    required int behavior,
    required int begin,
    required int end,
    required String major,
    required String minor,
  }) {
    _behavior = behavior;
    _operator = operator;
    _begin = begin;
    _end = end;
    _major = major;
    _minor = minor;
  }

  Map<String, dynamic> toJson() {
    return {
      'operator': utf8.encode(_operator),
      'behavior': _behavior,
      'begin': _begin,
      'end': _end,
      'major': _major,
      'minor': _minor,
    };
  }
}

class FetchTrackListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchTrackListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}
