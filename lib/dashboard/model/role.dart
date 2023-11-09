class Role {
  String _name;
  String _description;
  String _level;

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }

  Role(this._name, this._level, this._description);

  factory Role.fromJson(Map<String, dynamic> json) {
    String name = 'null', description = 'null', level = 'null';
    try {
      name = json['name'] ?? 'Empty';
      description = json['description'] ?? 'Empty';
      level = json['level'] ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return Role(
      name,
      level,
      description,
    );
  }
}
