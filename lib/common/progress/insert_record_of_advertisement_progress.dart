import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';

/*
three possible stage; requested, timeout, responded()
 */
class InsertRecordOfAdvertisementProgress {
  String from = 'InsertRecordOfAdvertisementProgress';
  int _result = -1;
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  bool _finished = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  Advertisement? _record;
  InsertRecordOfAdvertisementRsp? _rsp;

  InsertRecordOfAdvertisementProgress.construct({
    required int result,
    required Advertisement record,
  }) {
    _requested = false;
    _responded = false;
    _finished = false;
    _result = result;
    _record = record;
  }

  int result() {
    return _result;
  }

  void respond(InsertRecordOfAdvertisementRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  bool finished() {
    return _finished;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      _responded = false;
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
      );
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
