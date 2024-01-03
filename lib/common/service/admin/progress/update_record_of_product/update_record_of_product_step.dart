import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/update_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_record_of_product.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/utils/convert.dart';

class UpdateRecordOfProductStep {
  String from = 'SoftDeleteRecordsOfProductStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  UpdateRecordOfProductRsp? _rsp;
  String _name = '';
  String _productId = '';
  String _vendor = '';
  String _contact = '';
  String _buyingPrice = '';

  void setBuyingPrice(String buyingPrice) {
    _buyingPrice = buyingPrice;
  }

  void setContact(String contact) {
    _contact = contact;
  }

  void setVendor(String vendor) {
    _vendor = vendor;
  }

  void setName(String name) {
    _name = name;
  }

  void setProductId(String productId) {
    _productId = productId;
  }

  UpdateRecordOfProductStep.construct() {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void respond(UpdateRecordOfProductRsp rsp) {
    _rsp = rsp;
    _responded = true;
  }

  void skip() {
    _requested = true;
    _responded = true;
    _rsp = UpdateRecordOfProductRsp.fromJson({
      "body": {"code": Code.oK}
    });
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
      updateRecordOfProduct(
        from: from,
        caller: caller,
        name: _name,
        productId: int.parse(_productId),
        buyingPrice: Convert.doubleStringMultiple10toInt(_buyingPrice),
        vendor: _vendor,
        contact: _contact,
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
