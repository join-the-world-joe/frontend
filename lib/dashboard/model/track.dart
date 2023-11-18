import 'dart:convert';
import 'dart:math';

class Track {
  String _operator;
  String _major;
  String _minor;
  String _permission;
  String _request;
  String _response;
  String _timestamp;

  String getOperator() {
    return _operator;
  }

  String getMajor() {
    return _major;
  }

  String getMinor() {
    return _minor;
  }

  String getPermission() {
    return _permission;
  }

  String getRequest() {
    return _request;
  }

  String getResponse() {
    return _response;
  }

  String getTimestamp() {
    return _timestamp;
  }

  Track(
    this._operator,
    this._major,
    this._minor,
    this._permission,
    this._request,
    this._response,
    this._timestamp,
  );

  factory Track.fromJson(Map<String, dynamic> json) {
    String operator = '', major = '', minor = '', permission = '', request = '', response = '';
    String timestamp = '';
    try {
      operator = json['operator'] ?? 'Empty';
      major = json['major'] ?? 'Empty';
      minor = json['minor'] ?? 'Empty';
      timestamp = json['timestamp'] ?? 'Empty';
      permission = json['permission'] ?? 'Empty';
      request = jsonEncode(json['request']) ?? 'Empty';
      response = jsonEncode(json['response']) ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return Track(
      operator,
      major,
      minor,
      permission,
      request,
      response,
      timestamp,
    );
  }
}
