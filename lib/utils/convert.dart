
import 'dart:typed_data';
import 'dart:convert';

class Convert {
  static Uint8List toBytes(dynamic object) {
    Uint8List list = Uint8List.fromList(''.codeUnits);
    switch (object.runtimeType) {
      case Uint8List:
        return object;
      case String:
        try {
          list =  Uint8List.fromList(object.codeUnits);
        }
        catch(e) {
          // print('e: $e');
        }
        break;
      default:
        try {
          list = Uint8List.fromList(jsonEncode(object).codeUnits);
        }
        catch(e) {
          // print('e: $e');
        }
        break;
    }
    return list;
  }

  static String Bytes2String(Uint8List list) {
    return utf8.decode(list);
  }
}

