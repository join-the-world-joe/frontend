import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/insert_record_of_advertisement.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';

class InsertRecordOfAdvertisementStep {
  String from = 'InsertRecordOfAdvertisementStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  InsertRecordOfAdvertisementRsp? _rsp;
  bool _skip = false;
  Advertisement? _record;

  InsertRecordOfAdvertisementStep.construct({
    required Advertisement record,
  }) {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void respond(InsertRecordOfAdvertisementRsp rsp) {
    _rsp = rsp;
    _responded = true;
  }

  void skip() {
    _skip = true;
  }

  bool timeout() {
    if (!_responded && DateTime.now().isAfter(_requestTime.add(_defaultTimeout))) {
      return true;
    }
    return false;
  }

  int progress() {
    var caller = 'progress';
    if (_skip) {
      return Code.oK;
    }
    if (!_requested) {
      _requestTime = DateTime.now();
      insertRecordOfAdvertisement(
        from: from,
        caller: caller,
        name: _record!.getName(),
        title: _record!.getTitle(),
        sellingPrice: _record!.getSellingPrice(),
        sellingPoints: _record!.getSellingPoints(),
        coverImage: _record!.getCoverImage(),
        firstImage: _record!.getFirstImage(),
        secondImage: _record!.getSecondImage(),
        thirdImage: _record!.getThirdImage(),
        fourthImage: _record!.getFourthImage(),
        fifthImage: _record!.getFifthImage(),
        placeOfOrigin: _record!.getPlaceOfOrigin(),
        stock: _record!.getStock(),
        productId: _record!.getProductId(),
        ossFolder: _record!.getOSSFolder(),
        ossPath: _record!.getOSSPath(),
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
