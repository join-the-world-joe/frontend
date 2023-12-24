import 'dart:typed_data';

class ImageItem {
  bool _native = false; // false: in oss platform; true: in native file system
  String _nativeFileName = ''; // for native file
  Uint8List _data = Uint8List(0); // for native file
  String _objectFile = ''; // oss object file name
  String _url = ''; // uploaded; oss url
  String _dbKey = ''; // key of image of advertisement in database

  bool getNative() {
    return _native;
  }

  String getDBKey() {
    return _dbKey;
  }

  String getUrl() {
    return _url;
  }

  String getObjectFile() {
    return _objectFile;
  }

  Uint8List getData() {
    return _data;
  }

  String getNativeFileName() {
    return _nativeFileName;
  }

  ImageItem.construct({
    required bool native,
    required Uint8List data,
    required String objectFile,
    required String url,
    required String nativeFileName,
    required String dbKey,
  }) {
    _dbKey = dbKey;
    _native = native;
    _data = data;
    _objectFile = objectFile;
    _url = url;
    _nativeFileName = nativeFileName;
  }
}