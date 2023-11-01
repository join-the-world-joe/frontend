class Header {
  String _major = '';
  String _minor = '';

  Header();

  Header.build({required String major, required String minor}) {
    _major = major;
    _minor = minor;
  }

  void setMajor(String major) {
    _major = major;
  }

  String getMajor() {
    return _major;
  }

  void setMinor(String minor) {
    _minor = minor;
  }

  String getMinor() {
    return _minor;
  }

  Map<String, dynamic> toJson() => {
        "major": _major,
        "minor": _minor,
      };

  Header.fromJson(Map<String, dynamic> json)
      : _major = json['header']?['major'] ?? '',
        _minor = json['header']?['minor'] ?? '';
}
