import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/business/sign_in.dart';
import 'package:flutter_framework/common/service/admin/business/soft_delete_records_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/sign_in.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_product.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/utils/convert.dart';

class SoftDeleteRecordsOfProductStep {
  String from = 'SoftDeleteRecordsOfProductStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  SoftDeleteRecordsOfProductRsp? _rsp;
  List<int> _productIdList = [];

  void setProductIdList(List<int> idList) {
    _productIdList = idList;
  }

  SoftDeleteRecordsOfProductStep.construct() {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void respond(SoftDeleteRecordsOfProductRsp rsp) {
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
      softDeleteRecordsOfProduct(
        from: from,
        caller: caller,
        productIdList: _productIdList,
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
