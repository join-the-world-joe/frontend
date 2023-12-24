class RateLimiter {
  bool tried = false;
  DateTime _last = DateTime.now().add(const Duration(hours: -1));
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
    // print('major: $_major minor:$_minor last: ${_last.toString()} period: ${_period.toString()}');
    if (DateTime.now().isAfter(_last.add(Duration(milliseconds: _period)))) {
      _last = DateTime.now();
      // print('update last to ${_last.toString()}');
      return true;
    }
    return false;
  }
}
