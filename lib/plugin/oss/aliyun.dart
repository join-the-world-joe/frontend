import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class AliYunOSS {
  String _id = '';
  String _secret = '';
  String _endpoint = '';

  AliYunOSS.construct({
    required String id,
    required String secret,
    required String endpoint,
  }) {
    _id = id;
    _secret = secret;
    _endpoint = endpoint;
  }

  Future<String> putImageObject({
    required String bucket,
    required String objectFile,
    required File file,
    required Duration connectTimeout,
    required Duration receiveTimeout,
    required Function onProgress,
  }) async {
    String fileType = path.extension(file.path).toLowerCase();
    MediaType mediaType = MediaType('image', fileType);
    var headers = sign(
      httpMethod: 'PUT',
      resourcePath: '/$bucket/$objectFile',
      headers: {
        'content-type': mediaType.mimeType,
      },
    );

    try {
      final String url = 'https://$bucket.$_endpoint/$objectFile';
      final Uint8List bytes = file.readAsBytesSync();

      await Dio(BaseOptions(
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
      )).put<void>(
        url,
        data: Stream.fromIterable(bytes.map((e) => [e])),
        options: Options(
          headers: <String, dynamic>{
            ...headers,
            ...<String, dynamic>{
              'content-length': bytes.length,
            }
          },
          contentType: mediaType.mimeType,
        ),
        onSendProgress: (count, total) {
          onProgress(count, total);
        },
      );
      return url;
    } catch (e) {
      print('AliYunOSS.putObject failure, err: $e');
      return Future(() => '');
    }
  }

  String requestTime() {
    initializeDateFormatting('en', null);
    final DateTime now = DateTime.now();
    final String string = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_ISO').format(now.toUtc());
    return '$string GMT';
  }

  String calcHMACSha1(String plaintext) {
    final digest = Hmac(sha1, utf8.encode(_secret)).convert(utf8.encode(plaintext));
    return base64.encode(digest.bytes);
  }

  List<MapEntry<String, String>> sortByLowerKey(Map<String, String> map) {
    final lowerPairs = map.entries.map((e) => MapEntry(e.key.toLowerCase().trim(), e.value.toString().trim()));
    return lowerPairs.toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  String buildCanonicalizedResource(String resourcePath, Map<String, String> parameters) {
    if (parameters.isNotEmpty == true) {
      final queryString = sortByLowerKey(parameters).map((e) => '${e.key}=${e.value}').join('&');
      return '$resourcePath?$queryString';
    }
    return resourcePath;
  }

  Map<String, String> sign({
    required String httpMethod,
    required String resourcePath,
    Map<String, String>? parameters,
    Map<String, String>? headers,
  }) {
    final securityHeaders = {
      if (headers != null) ...headers,
    };
    final sortedHeaders = sortByLowerKey(securityHeaders);
    final contentType = sortedHeaders
        .firstWhere(
          (e) => e.key == 'content-type',
          orElse: () => const MapEntry('', ''),
        )
        .value;
    final canonicalizedOSSHeaders = sortedHeaders.where((e) => e.key.startsWith('x-oss-')).map((e) => '${e.key}:${e.value}').join('\n');

    final securityParameters = {
      if (parameters != null) ...parameters,
    };
    final canonicalizedResource = buildCanonicalizedResource(resourcePath, securityParameters);

    final date = requestTime();
    final canonicalString = [
      httpMethod,
      '', // md5 of content
      contentType,
      date,
      if (canonicalizedOSSHeaders.isNotEmpty) canonicalizedOSSHeaders,
      canonicalizedResource,
    ].join('\n');

    final signature = calcHMACSha1(canonicalString);
    return {
      'Date': date,
      'Authorization': 'OSS $_id:$signature',
    };
  }
}
