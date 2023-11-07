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
}
