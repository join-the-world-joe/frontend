import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_product.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

class InsertRecordOfAdvertisementStep {
  String from = 'InsertRecordOfAdvertisementStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  InsertRecordOfProductRsp? _rsp;
  String _name = '';
  String _vendor = '';
  String _contact = '';
  int _buyingPrice = 0;

  InsertRecordOfAdvertisementStep.construct() {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void setName(String name) {
    _name = name;
  }

  void setVendor(String vendor) {
    _vendor = vendor;
  }

  void setContact(String contact) {
    _contact = contact;
  }

  void setBuyingPrice(int buyingPrice) {
    _buyingPrice = buyingPrice;
  }

  void respond(InsertRecordOfProductRsp rsp) {
    _rsp = rsp;
    _responded = true;
  }

  void skip() {
    _requested = true;
    _responded = true;
    _rsp = InsertRecordOfProductRsp.fromJson({
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
      insertRecordOfProduct(
        from: from,
        caller: caller,
        name: _name,
        vendor: _vendor,
        contact: _contact,
        buyingPrice: _buyingPrice,
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
