import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/service/admin/business/update_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_record_of_product.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/dashboard/local/image_item.dart';
import 'package:flutter_framework/utils/convert.dart';

class UpdateRecordOfAdvertisementStep {
  String from = 'UpdateRecordOfAdvertisementStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  UpdateRecordOfAdvertisementRsp? _rsp;
  int _id = 0;
  String _coverImage = '';
  String _firstImage = '';
  String _secondImage = '';
  String _thirdImage = '';
  String _fourthImage = '';
  String _fifthImage = '';
  String _name = '';
  String _title = '';
  int _stock = 0;
  int _status = 1;
  int _productId = 0;
  int _sellingPrice = 0;
  List<String> _sellingPoints = [];
  String _placeOfOrigin = '';

  UpdateRecordOfAdvertisementStep.construct({
    required int id,
    required String coverImage,
    required String firstImage,
    required String secondImage,
    required String thirdImage,
    required String fourthImage,
    required String fifthImage,
    required String name,
    required String title,
    required int stock,
    required int status,
    required int productId,
    required int sellingPrice,
    required List<String> sellingPoints,
    required String placeOfOrigin,
  }) {
    _rsp = null;
    _requested = false;
    _responded = false;
    _id = id;
    _coverImage = coverImage;
    _firstImage = firstImage;
    _secondImage = secondImage;
    _thirdImage = thirdImage;
    _fourthImage = fourthImage;
    _fifthImage = fifthImage;
    _name = name;
    _title = title;
    _stock = stock;
    _status = status;
    _productId = productId;
    _sellingPrice = sellingPrice;
    _sellingPoints = sellingPoints;
    _placeOfOrigin = placeOfOrigin;
  }

  int getCode() {
    if (_rsp != null) {
      return _rsp!.getCode();
    }
    return 1;
  }

  void respond(UpdateRecordOfAdvertisementRsp rsp) {
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
      // put business logic here
      updateRecordOfAdvertisement(
        from: from,
        caller: caller,
        id: _id,
        coverImage: _coverImage,
        firstImage: _firstImage,
        secondImage: _secondImage,
        thirdImage: _thirdImage,
        fourthImage: _fourthImage,
        fifthImage: _fifthImage,
        name: _name,
        title: _title,
        stock: _stock,
        status: _status,
        productId: _productId,
        sellingPrice: _sellingPrice,
        sellingPoints: _sellingPoints,
        placeOfOrigin: _placeOfOrigin,
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
