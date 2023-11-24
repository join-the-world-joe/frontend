import 'field.dart';

class FieldList {
  List<Field> _body = [];
  int _length = 0;

  FieldList(List<Field> any) {
    _body = any;
    _length = any.length;
  }

  List<Field> getBody() {
    return _body;
  }

  int getLength() {
    return _length;
  }

  factory FieldList.fromJson(Map<String, dynamic> json) {
    List<Field> fl = [];
    try {
      if (json['field_list'] != null) {
        List<dynamic> any = json['field_list'];
        any.forEach(
              (element) {
            fl.add(Field.fromJson(element));
          },
        );
      }
      return FieldList(fl);
    } catch (e) {
      print('FieldList failure, e: $e');
    }

    return FieldList(fl);
  }
}
