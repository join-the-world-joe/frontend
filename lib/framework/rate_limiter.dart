class RateLimiter {
  bool tried = false;
  DateTime? _last;
  final int _major;
  final int _minor;
  final int _period;

  int getMajor() {
    return _major;
  }

  int getMinor() {
    return _minor;
  }

  int getPeriod() {
    return _period;
  }

  RateLimiter(this._major, this._minor, this._period);

  bool allow() {
    if (_last == null) {
      _last = DateTime.now();
      return true;
    } else {
      if (DateTime.now().isAfter(_last!.add(Duration(milliseconds: _period)))) {
        _last = DateTime.now();
        return true;
      }
      return false;
    }
  }
}
