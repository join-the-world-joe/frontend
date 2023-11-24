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
    String name = 'null', description = 'null', table = 'null';
    try {
      name = json['name'] ?? 'Empty';
      description = json['description'] ?? 'Empty';
      table = json['table'] ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return Field(name, table, description);
  }
}
