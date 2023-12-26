import 'dart:core';

import 'package:flutter_framework/common/business/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

/*
three possible stage; requested, timeout, responded()
 */
class UpgradeFieldsOfAdvertisementProgress {
  String from = 'UpgradeFieldsOfAdvertisementProgress';
  int _result = Code.internalError;
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  bool _finished = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  UpdateRecordOfAdvertisementRsp? _rsp;
  int _advertisementId = -1;
  String _image = '';
  String _name = '';
  String _title = '';
  int _stock = -1;
  int _status = -1;
  int _productId = -1;
  int _sellingPrice = -1;
  List<String> _sellingPoints = [];
  String _placeOfOrigin = '';

  UpgradeFieldsOfAdvertisementProgress.construct({
    required int result,
    required int id,
    required String image,
    required String name,
    required String title,
    required int stock,
    required int status,
    required int productId,
    required int sellingPrice,
    required List<String> sellingPoints,
    required String placeOfOrigin,
  }) {
    _requested = false;
    _responded = false;
    _finished = false;
    _result = result;
    _advertisementId = id;
    _image = image;
    _name = name;
    _title = title;
    _stock = stock;
    _status = status;
    _productId = productId;
    _sellingPrice = sellingPrice;
    _sellingPoints = sellingPoints;
    _placeOfOrigin = placeOfOrigin;
  }

  int result() {
    return _result;
  }

  void respond(UpdateRecordOfAdvertisementRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  bool finished() {
    return _finished;
  }

  void setAdvertisementId(int id) {
    _advertisementId = id;
  }

  void setImage(String image) {
    _image = image;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      updateRecordOfAdvertisement(
        from: from,
        caller: caller,
        id: _advertisementId,
        image: _image,
        name: _name,
        title: _title,
        stock: _stock,
        status: _status,
        productId: _productId,
        sellingPrice: _sellingPrice,
        sellingPoints: _sellingPoints,
        placeOfOrigin: _placeOfOrigin,
      );
      _responded = false;
      _requestTime = DateTime.now();
      _requested = true;
    }
    if (_requested) {
      if (!_responded && DateTime.now().isAfter(_requestTime.add(_defaultTimeout))) {
        _finished = true;
        return _result;
      }
      if (_responded) {
        if (_rsp != null) {
          if (_rsp!.getCode() == Code.oK) {
            _result = _rsp!.getCode();
            _finished = true;
            return Code.oK;
          }
        }
        _finished = true;
        return _result;
      }
    }
    return _result * -1;
  }
}
