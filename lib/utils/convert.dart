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

  static List<dynamic> utf8EncodeListString(List<String> input) {
    List<dynamic> output = [];
    try {
      List<dynamic> temp = [];
      for (var element in input) {
        temp.add(utf8.encode(element));
      }
      output = temp;
    } catch (e) {
      print('Convert.utf8EncodeListString failure, err: $e');
    }

    return output;
  }

  static dynamic utf8Encode(String input) {
    dynamic output = '';
    try {
      var temp = utf8.encode(input);
      output = temp;
    } catch (e) {
      print('Convert.utf8Encode failure, err: $e');
    }
    return output;
  }

  static List<String> jsonStringToListString(String input) {
    return (jsonDecode(input) as List<dynamic>).cast<String>();
  }

  static List<String> base64StringList2ListString(List<String> input) {
    List<String> output = [];
    for (var e in input) {
      output.add(bytes2String(base64Decode(e)));
    }
    return output;
  }

  static int doubleStringMultiple10toInt(String input) {
    int output = -999999;
    try {
      var temp = (double.parse(input) * 10).toInt();
      output = temp;
    } catch (e) {
      print('doubleMultiple10toInt failure($input), err: $e');
    }
    return output;
  }

  static String intDivide10toDoubleString(int input) {
    String output = input.toString();
    try {
      String temp = (double.parse(input.toString()) / 10).toString();
      output = temp;
    } catch (e) {
      print('intDivide10toDoubleString failure($input), err: $e');
    }
    return output;
  }

  static int doubleToInt(double input) {
    int output = 0;
    try {
      var temp = input.toInt();
      output = temp;
    } catch (e) {
      print('doubleToInt failure($input), err: $e');
    }
    return output;
  }
}
