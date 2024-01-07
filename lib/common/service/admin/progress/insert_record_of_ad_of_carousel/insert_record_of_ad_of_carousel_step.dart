import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_ad_of_carousel.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_ad_of_carousel.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

class InsertRecordOfADOfCarouselStep {
  String from = 'InsertRecordOfADOfCarouselStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  InsertRecordOfADOfCarouselRsp? _rsp;
  List<int> _advertisementIdList = [];

  InsertRecordOfADOfCarouselStep.construct({
    required List<int> advertisementIdList,
  }) {
    _rsp = null;
    _requested = false;
    _responded = false;
    _advertisementIdList = advertisementIdList;
  }

  int getCode() {
    if (_rsp != null) {
      return _rsp!.getCode();
    }
    return 1;
  }

  void respond(InsertRecordOfADOfCarouselRsp rsp) {
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
      insertRecordOfADOfCarousel(
        from: from,
        caller: caller,
        advertisementIdList: _advertisementIdList,
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
