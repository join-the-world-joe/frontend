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
          list = Uint8List.fromList(object.codeUnits);
        } catch (e) {
          print('Convert failure, e: $e');
        }
        break;
      default:
        try {
          list = Uint8List.fromList(jsonEncode(object).codeUnits);
        } catch (e) {
          print('Convert failure, e: $e');
        }
        break;
    }
    return list;
  }

  static String bytes2String(Uint8List list) {
    return utf8.decode(list);
  }

  static List<dynamic> utf8Encode(List<String> temp) {
    List<dynamic> output = [];
    for (var element in temp) {
      output.add(utf8.encode(element));
    }
    return output;
  }

  static String stringList2Json(List<String> input) {
    String output = "[";
    for (var i = 0; i < input.length; i++) {
      if (i < input.length - 1) {
        output += "\"${input[i]}\",";
        continue;
      }
      output += "\"${input[i]}\"";
    }
    output += "]";
    return output;
  }

  static List<String> jsonStringToListString(String input) {
    return (jsonDecode(input) as List<dynamic>).cast<String>();
  }
}
