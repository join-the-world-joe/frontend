import 'package:flutter_framework/common/code/code.dart';

class FetchHeaderListOfObjectFileListReq {
  List<String> _nameListOfFile = [];

  FetchHeaderListOfObjectFileListReq.construct({
    required List<String> nameListOfFile,
  }) {
    _nameListOfFile = nameListOfFile;
  }

  Map<String, dynamic> toJson() {
    return {
      "name_list_of_file": _nameListOfFile,
    };
  }
}

class ObjectFileRequestHeader {
  String _authorization = '';
  String _contentType = '';
  String _date = '';
  String _xOssDate = '';

  ObjectFileRequestHeader.construct({
    required String authorization,
    required String contentType,
    required String date,
    required String xOssDate,
  }) {
    _authorization = authorization;
    _contentType = contentType;
    _date = date;
    _xOssDate = xOssDate;
  }

  String getAuthorization() {
    return _authorization;
  }

  String getContentType() {
    return _contentType;
  }

  String getDate() {
    return _date;
  }

  String getXOssDate() {
    return _xOssDate;
  }

  @override
  String toString() {
    return 'Authorization:$_authorization Content-Type:$_contentType Date:$_date x-oss-date:$_xOssDate';
  }
}

class FetchHeaderListOfObjectFileListRsp {
  int _code = -1;
  String _host = '';
  String _commonPath = '';
  Map<String, ObjectFileRequestHeader> _requestHeader = {};

  String getHost() {
    return _host;
  }

  int getCode() {
    return _code;
  }

  String getCommonPath() {
    return _commonPath;
  }

  Map<String, ObjectFileRequestHeader> getRequestHeader() {
    return _requestHeader;
  }

  FetchHeaderListOfObjectFileListRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (_code == Code.oK) {
      if (json.containsKey('body')) {
        Map<String, dynamic> body = json['body'];
        if (body.containsKey('common_path')) {
          _commonPath = body['common_path'];
        }
        if (body.containsKey('host')) {
          _host = body['host'];
        }
        if (body.containsKey('request_header')) {
          Map<String, dynamic> temp = body['request_header'];
          temp.forEach((key, value) {
            _requestHeader[key] = () {
              return ObjectFileRequestHeader.construct(authorization: value['authorization'], contentType: value['content_type'], date: value['date'], xOssDate: value['x_oss_date']);
            }();
          });
        }
      }
    }
  }
}
