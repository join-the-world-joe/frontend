import 'dart:convert';
import 'dart:math';

class Track {
  String _operator = '';
  String _major = '';
  String _minor = '';
  String _permission = '';
  String _request = '';
  String _response = '';
  String _timestamp = '';

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

  Track.construct({
    required String operator,
    required String major,
    required String minor,
    required String permission,
    required String request,
    required String response,
    required String timestamp,
  }) {
    _operator = operator;
    _major = major;
    _minor = minor;
    _permission = permission;
    _request = request;
    _response = response;
    _timestamp = timestamp;
  }

// Track(
//   this._operator,
//   this._major,
//   this._minor,
//   this._permission,
//   this._request,
//   this._response,
//   this._timestamp,
// );

  // factory Track.fromJson(Map<String, dynamic> json) {
  //   return Track.construct(
  //     operator: json['operator'],
  //     major: json['major'],
  //     minor: json['minor'],
  //     permission: json['permission'],
  //     request: json['request'],
  //     response: json['response'],
  //     timestamp: json['timestamp'],
  //   );
  // }
}
