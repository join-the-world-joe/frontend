import 'package:flutter_framework/common/translator/language.dart';

class Field {
  String _name = '';
  String _table = '';
  String _description = '';

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }

  String getTable() {
    return _table;
  }

  Field.construct({
    required String name,
    required String table,
    required String description,
  }) {
    _name = name;
    _table = table;
    _description = description;
  }
}
