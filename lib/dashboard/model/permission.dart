class Permission {
  final String _name;
  final String _major;
  final String _minor;
  final String _description;

  String getName() {
    return _name;
  }

  String getMajor() {
    return _major;
  }

  String getMinor() {
    return _minor;
  }

  String getDescription() {
    return _description;
  }

  Permission(this._name, this._major, this._minor, this._description);

  factory Permission.fromJson(Map<String, dynamic> json) {
    String name = 'null', description = 'null', major = 'null', minor = 'null';
    try {
      name = json['name'] ?? 'Empty';
      description = json['description'] ?? 'Empty';
      major = json['major'] ?? 'Empty';
      minor = json['minor'] ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return Permission(name, major, minor, description);
  }
}
