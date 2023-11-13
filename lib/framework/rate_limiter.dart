
class RateLimiter {
  final Duration _period; // in milliseconds
  DateTime _last = DateTime.now();

  RateLimiter(this._period);

  bool allow() {
    if (DateTime.now().isAfter(_last.add(_period))) {
      _last = DateTime.now();
      return true;
    }
    return false;
  }
}
