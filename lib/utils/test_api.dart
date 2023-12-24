import 'dart:io';
import './api.dart';

void putImage() async {
  File file = File("D:\\Projects\\github\\mini_program\\asset\\image\\1.jpg");
  Map<String, String> header = {
    "Authorization": "",
    "Content-Type": "",
    "Date":"",
    "x-oss-date":"",
  };
  var result = await API.put(
    scheme: 'https',
    host: 'advertisement-image.oss-cn-shenzhen.aliyuncs.com',
    port: '',
    endpoint: '15/0.jpg', // name has to be the same as the name in sign operation
    timeout: Duration(seconds: 30),
    header: header,
    body: file.readAsBytesSync(),
  );

  print('code: ${result.getCode()}');
}

/*
    api_test.go:113: headers:  {"Authorization":["OSS LTAI5tCB8kLgV7rYbBDHekKx:QWytCgJ37YFbnDoMAuyy6FsIYBA="],"Content-Type":[""],"Date":["Sun, 24 Dec 2023 03:37:19 GMT"],"X-Oss-Date":["Sun, 24 Dec 2023 03:37:19 GMT"]}

 */
void putVideo() async {
  File file = File("C:\\Users\\Joe\\Desktop\\oss\\1.mp4");
  Map<String, String> header = {
    "Authorization": "",
    "Content-Type": "",
    "Date":"",
    "x-oss-date":"",
  };
  var result = await API.put(
    scheme: 'https',
    host: 'advertisement-image.oss-cn-shenzhen.aliyuncs.com',
    port: '',
    endpoint: '1.mp4', // name has to be the same as the name in sign operation
    timeout: Duration(minutes: 2),
    header: header,
    body: file.readAsBytesSync(),
  );

  print('code: ${result.getCode()}');
}

void main() async {
  putVideo();
}
