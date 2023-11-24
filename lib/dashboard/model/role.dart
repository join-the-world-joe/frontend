import 'dart:convert';

class Role {
  String _name;
  String _description;
  String _department;
  int _rank;

  String getName() {
    return _name;
  }

  String getDescription() {
    return _description;
  }

  int getRank() {
    return _rank;
  }

  String getDepartment() {
    return _department;
  }

  Role(this._name, this._rank, this._description, this._department);

  factory Role.fromJson(Map<String, dynamic> json) {
    String name = 'null', description = 'null', department = 'null';
    int rank = 0;
    try {
      name = json['name'] ?? 'Empty';
      description = json['description'] ?? 'Empty';
      rank = json['rank'] ?? 'Empty';
      department = json['department'] ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return Role(name, rank, description, department);
  }
}
