import 'package:flutter_framework/common/translator/language.dart';

class Field {
  String _name;
  String _table;
  String _description;

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }

  String getTable() {
    return _table;
  }

  Field(this._name, this._table, this._description);

  factory Field.fromJson(Map<String, dynamic> json) {
    String name = Language.valueOfNull, description = Language.valueOfNull, table = Language.valueOfNull;
    try {
      name = json['name'] ?? Language.valueOfNull;
      description = json['description'] ?? Language.valueOfNull;
      table = json['table'] ?? Language.valueOfNull;
    } catch (e) {
      print('e: $e');
    }
    return Field(name, table, description);
  }
}
