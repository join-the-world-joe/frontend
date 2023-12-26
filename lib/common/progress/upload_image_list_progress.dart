import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/utils/api.dart';

/*
three possible stage; requested, timeout, responded()
 */
class UploadImageListProgress {
  String from = 'InsertRecordOfAdvertisementProgress';
  int _result = -1;
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _finished = false;
  int _imageCount = 0;
  int _failureCount = 0;
  int _totalImageCount = 0;
  Map<String, Uint8List> _objectDataMapping = {};
  String _ossHost = '';
  Map<String, ObjectFileRequestHeader> _requestHeader = {};

  UploadImageListProgress.construct({
    required int result,
    required String ossHost,
    required Map<String, ObjectFileRequestHeader> requestHeader,
    required Map<String, Uint8List> objectDataMapping,
  }) {
    _ossHost = ossHost;
    _requested = false;
    _finished = false;
    _result = result;
    _requestHeader = requestHeader;
    _objectDataMapping = objectDataMapping;
    _totalImageCount = _objectDataMapping.length;
  }

  int result() {
    return _result;
  }

  bool finished() {
    return _finished;
  }

  void setOSSHost(String host) {
    _ossHost = host;
  }

  void setRequestHeader(Map<String, ObjectFileRequestHeader> requestHeader) {
    _requestHeader = requestHeader;
  }

  void setObjectDataMapping(Map<String, Uint8List> objectDataMapping) {
    _objectDataMapping = objectDataMapping;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      _requestTime = DateTime.now();
      _objectDataMapping.forEach(
            (key, value) {
          API
              .put(
            scheme: 'https://',
            host: _ossHost,
            port: '',
            endpoint: key,
            timeout: Config.httpDefaultTimeout,
            header: {
              "Authorization": _requestHeader[key]!.getAuthorization(),
              "Content-Type": _requestHeader[key]!.getContentType(),
              "Date": _requestHeader[key]!.getDate(),
              "x-oss-date": _requestHeader[key]!.getXOssDate(),
            },
            body: value,
          ).then((value){
            if (value.getCode() == Code.oK) {
              _imageCount++;
            } else {
              _failureCount++;
            }
          });
        },
      );
      _requested = true;
    }
    if (_requested) {
      if (_imageCount + _failureCount == _totalImageCount) {
        if (_failureCount == 0) {
          _result = Code.oK;
        }
        _finished = true;
      }
      if (!_finished && DateTime.now().isAfter(_requestTime.add(Duration(seconds: Config.httpDefaultTimeoutInSecond * _totalImageCount)))) {
        _finished = true;
        return _result;
      }
    }
    return _result * -1;
  }
}
