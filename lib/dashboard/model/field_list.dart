import 'field.dart';

class FieldList {
  List<Field> _body = [];

  FieldList(List<Field> any) {
    _body = any;
  }

  List<Field> getBody() {
    return _body;
  }

  int getLength() {
    return _body.length;
  }

  FieldList.fromJson(Map<String, dynamic> json) {
    List<Field> fl = [];
    if (json.containsKey('field_list')) {
      List<dynamic> any = json['field_list'];
      for (var element in any) {
        Map<String, dynamic> map = Map.from(element);
        fl.add(Field.construct(
          name: map['name'],
          table: map['table'],
          description: map['description'],
        ));
      }
    }
    _body = fl;
  }
}
