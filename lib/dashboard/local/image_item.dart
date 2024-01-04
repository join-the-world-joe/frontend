import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker_web/image_picker_web.dart';

class ImageItem {
  bool _native = false; // false: in oss platform; true: in native file system
  String _nativeFileName = ''; // for native file
  Uint8List _data = Uint8List(0); // for native file
  String _objectFileName = ''; // oss object file name
  String _url = ''; // uploaded; oss url
  int _width = 0;
  int _height = 0;

  int getFileSize() {
    // only for native file
    return _data.length;
  }

  int getWidth() {
    return _width;
  }

  int getHeight() {
    return _height;
  }

  bool getNative() {
    return _native;
  }

  String getUrl() {
    return _url;
  }

  String getObjectFileName() {
    return _objectFileName;
  }

  Uint8List getData() {
    return _data;
  }

  void setUrl(String url) {
    _url = url;
  }

  String getNativeFileName() {
    return _nativeFileName;
  }

  static String transToImageField(ImageItem? item) {
    var output = '';
    try {
      Map<String, String> temp = {};
      if (item != null) {
        temp['width'] = item.getWidth().toString();
        temp['height'] = item.getHeight().toString();
        temp['object_file_name'] = item.getObjectFileName();
        output = jsonEncode(temp);
      }
    } catch (e) {
      print('ImageItem.genImageField failure, e: $e');
    }
    return output;
  }

  ImageItem.construct({
    required bool native,
    required Uint8List data,
    required String objectFileName,
    required String url,
    required String nativeFileName,
    required int width,
    required int height,
  }) {
    _native = native;
    _width = width;
    _height = height;
    _data = data;
    _objectFileName = objectFileName;
    _url = url;
    _nativeFileName = nativeFileName;
  }

  static Future<ImageItem> fromMediaInfo({
    required MediaInfo mediaInfo,
    required String prefix,
    required String ossFolder,
  }) async {
    var timestamp = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    var nativeFileName = mediaInfo.fileName!;
    var fileSize = mediaInfo.data!.length;
    ui.Codec codec = await ui.instantiateImageCodec(mediaInfo.data!);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    int width = frameInfo.image.width;
    int height = frameInfo.image.height;
    String extension = path.extension(mediaInfo.fileName!).toLowerCase();
    var objectFileName = '$ossFolder/$prefix$timestamp$extension';
    print('file name: $nativeFileName');
    print('extension: $extension');
    print('size: $fileSize');
    print('object file Name: $objectFileName');
    print("width: $width");
    print("height: $height");

    return ImageItem.construct(
      native: true,
      data: mediaInfo.data!,
      objectFileName: objectFileName,
      url: '',
      nativeFileName: nativeFileName,
      width: width,
      height: height,
    );
  }
}
