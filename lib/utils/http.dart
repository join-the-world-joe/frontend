import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/framework/result.dart';
import 'package:http/http.dart' as http;

class HTTP {
  static Future<Result> get({required String scheme, required String host, required String port, required String endpoint, required Map<String, String> header, required Map<String, dynamic> query, required Duration timeout}) async {
    http.Response rsp;
    var uri = scheme == "http" ? Uri.http('$host:$port', endpoint, query) : Uri.https('$host:$port', endpoint, query);
    try {
      rsp = await http.get(uri, headers: header).timeout(timeout);
    } catch (e) {
      if (e == TimeoutException) {
        return Result.construct(
          code: Code.serviceRequestTimeout,
          body: '',
        );
      } else {
        print(e);
        return Result.construct(
          code: Code.unHandledException,
          body: '',
        );
      }
    }
    if (rsp.statusCode == HttpStatus.ok) {
      return Result.construct(
        code: Code.oK,
        body: rsp.body,
      );
    }
    print('status code: ${rsp.statusCode}');
    return Result.construct(
      code: Code.requestAborted,
      body: '',
    );
  }

  static Future<Result> postURLEncodedForm({required String scheme, required String host, required String port, required String endpoint, required Map<String, String> header, required Map<String, dynamic> form, required Duration timeout}) async {
    http.Response rsp;
    var uri = scheme == "http" ? Uri.http('$host:$port', endpoint) : Uri.https('$host:$port', endpoint);
    try {
      if (!header.containsKey("Content-Type")) {
        header["Content-Type"] = "application/x-www-form-urlencoded";
      }
      rsp = await http
          .post(
            uri,
            headers: header,
            encoding: Encoding.getByName('utf-8'),
            body: form,
          )
          .timeout(timeout);
    } catch (e) {
      if (e == TimeoutException) {
        return Result.construct(
          code: Code.serviceRequestTimeout,
          body: '',
        );
      } else {
        print(e);
        return Result.construct(
          code: Code.unHandledException,
          body: '',
        );
      }
    }
    if (rsp.statusCode == HttpStatus.ok) {
      return Result.construct(
        code: Code.oK,
        body: rsp.body,
      );
    }
    print('status code: ${rsp.statusCode}');
    return Result.construct(
      code: Code.requestAborted,
      body: '',
    );
  }

  static Future<Result> postRawJsonBody({
    required String scheme,
    required String host,
    required String port,
    required String endpoint,
    required Map<String, String> header,
    required Map<String, dynamic> body,
    required Duration timeout,
  }) async {
    http.Response rsp;
    var uri = scheme == "http" ? Uri.http('$host:$port', endpoint) : Uri.https('$host:$port', endpoint);
    try {
      if (!header.containsKey("Content-Type")) {
        header["Content-Type"] = "application/json";
      }
      rsp = await http
          .post(
            uri,
            headers: header,
            encoding: Encoding.getByName('utf-8'),
            body: jsonEncode(body),
          )
          .timeout(timeout);
    } catch (e) {
      if (e == TimeoutException) {
        return Result.construct(
          code: Code.serviceRequestTimeout,
          body: '',
        );
      } else {
        print('PostRawJsonBody fail, $e');
        return Result.construct(
          code: Code.networkUnreachable,
          body: '',
        );
      }
    }
    if (rsp.statusCode == HttpStatus.ok) {
      return Result.construct(code: Code.oK, body: rsp.body);
    }
    print('status code: ${rsp.statusCode}');
    return Result.construct(
      code: Code.requestAborted,
      body: '',
    );
  }
}
