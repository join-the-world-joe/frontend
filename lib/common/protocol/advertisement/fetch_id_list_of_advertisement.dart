import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchIdListOfAdvertisementReq {
  int _behavior = -1;
  String _advertisementName = '';

  FetchIdListOfAdvertisementReq.construct({
    required int behavior,
    required String advertisementName,
  }) {
    _behavior = behavior;
    _advertisementName = advertisementName;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'advertisement_name': utf8.encode(_advertisementName),
    };
  }
}

class FetchIdListOfAdvertisementRsp {
  int _code = -1;
  int _behavior = -1;
  List<int> _idList = [];

  int getCode() {
    return _code;
  }

  List<int> getIdList() {
    return _idList;
  }

  int getBehavior() {
    return _behavior;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  FetchIdListOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json['code'] != null) {
      _code = json['code'] ?? -1;
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('behavior')) {
        _behavior = body['behavior'];
      }
      if (body['id_list_of_advertisement'] != null) {
        _idList = List<int>.from(body['id_list_of_advertisement'] as List);
      }
    }
  }
}

