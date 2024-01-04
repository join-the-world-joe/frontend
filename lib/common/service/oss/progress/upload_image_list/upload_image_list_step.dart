import 'dart:typed_data';

import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/oss/business/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/utils/api.dart';

class UploadImageListStep {
  String from = 'UploadImageListStep';
  bool _requested = false;
  bool _skip = false;
  String _ossHost = '';
  Map<String, ObjectFileRequestHeader> _requestHeader = {};
  Map<String, Uint8List> _objectDataMapping = {};
  int _imageCount = 0;
  int _failureCount = 0;
  int _totalImageCount = 0;

  UploadImageListStep.construct({
    required String ossHost,
    required Map<String, ObjectFileRequestHeader> requestHeader,
    required Map<String, Uint8List> objectDataMapping,
  }) {
    _ossHost = ossHost;
    _requested = false;
    _requestHeader = requestHeader;
    _objectDataMapping = objectDataMapping;
    _totalImageCount = _objectDataMapping.length;
  }

  void setRequestHeader(Map<String, ObjectFileRequestHeader> requestHeader) {
    _requestHeader = requestHeader;
  }

  void setObjectDataMapping(Map<String, Uint8List> objectDataMapping) {
    _objectDataMapping = objectDataMapping;
  }

  void setOSSHost(String host) {
    _ossHost = host;
  }

  void skip() {
    _skip = true;
    _requested = false;
  }

  int progress() {
    if (_skip) {
      return Code.oK;
    }
    if (!_requested) {
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
          )
              .then((value) {
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
          return Code.oK;
        }
        return Code.internalError;
      }
      return Code.internalError * -1;
    }
    return Code.internalError * -1;
  }
}
