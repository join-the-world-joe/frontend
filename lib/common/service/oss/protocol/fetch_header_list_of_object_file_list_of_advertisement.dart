/*
type FetchHeaderListOfObjectFileListOfAdvertisementReq struct {
UserId          int64
AdvertisementId int64    `json:"advertisement_id"`
NameListOfFile  []string `json:"name_list_of_file"`
}

type FetchHeaderListOfObjectFileListOfAdvertisementRsp struct {
Code int             `json:"code"`
Body json.RawMessage `json:"body"`
}
 */

class FetchHeaderListOfObjectFileListOfAdvertisementReq {
  String _ossFolder = '';
  List<String> _nameListOfFile = [];

  FetchHeaderListOfObjectFileListOfAdvertisementReq.construct({
    required String ossFolder,
    required List<String> nameListOfFile,
  }) {
    _ossFolder = ossFolder;
    _nameListOfFile = nameListOfFile;
  }

  Map<String, dynamic> toJson() {
    return {
      "oss_folder": _ossFolder,
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

class FetchHeaderListOfObjectFileListOfAdvertisementRsp {
  int _code = -1;
  String _host = '';
  int _advertisementId = -1;
  String _commonPath = '';
  Map<String, ObjectFileRequestHeader> _requestHeader = {};

  String getHost() {
    return _host;
  }

  int getCode() {
    return _code;
  }

  int getAdvertisementId() {
    return _advertisementId;
  }

  String getCommonPath() {
    return _commonPath;
  }

  Map<String, ObjectFileRequestHeader> getRequestHeader() {
    return _requestHeader;
  }

  FetchHeaderListOfObjectFileListOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('advertisement_id')) {
        _advertisementId = body['advertisement_id'];
      }
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
            return ObjectFileRequestHeader.construct(
              authorization: value['authorization'],
              contentType: value['content_type'],
              date: value['date'],
              xOssDate: value['x_oss_date']
            );
          }();
        });
      }
    }
  }
}
