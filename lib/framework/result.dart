class Result {
  int _code = -1;
  String _body = '';

  Result.construct({required int code, required String body}) {
    _code = code;
    _body = body;
  }

  int getCode() {
    return _code;
  }

  String getBody() {
    return _body;
  }
}
