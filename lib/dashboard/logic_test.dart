import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/business/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/framework/rate_limiter.dart';
import 'package:flutter_framework/utils/convert.dart';

class LogicTest extends StatefulWidget {
  const LogicTest({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<LogicTest> {
  var last = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      var d = DateTime.parse('2023-11-8');
      print("d: ${d.millisecondsSinceEpoch/1000}");
    });
  }
}

// class LogicTest extends StatelessWidget {
//   LogicTest({Key? key}) : super(key: key);
//   RateLimiter pressLimiter = RateLimiter(const Duration(milliseconds: 500));
//   String data = '{"code":0,"body":{"Admission":["User","Role","Permission","Menu"]}}';
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         if (pressLimiter.allow()) {
//           print('allow');
//         }
//       },
//       child: Text('data'),
//     );
//   }
// }
//
// class LogicTest extends StatelessWidget {
//   LogicTest({Key? key}) : super(key: key);
//
//   String data = '{"code":0,"body":{"Admission":["User","Role","Permission","Menu"]}}';
//
//   @override
//   Widget build(BuildContext context) {
//     var temp = jsonDecode(data);
//     print('temp: $temp');
//     // var rsp = FetchMenuListOfRoleListReq([]).fromJson(temp);
//     // print(rsp.toString());
//     // print(rsp.body.toString());
//     // print(Convert.toBytes(rsp.body));
//     // var ml = MenuList.fromJson(rsp.body);
//     // print(ml);
//     return const Text('LogicTest');
//   }
// }

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}

// static PacketClient fromBytes(Uint8List list) {
// try {
// return PacketClient.fromJson(jsonDecode(Convert.Bytes2String(list)));
// } catch (e) {
// // print('PacketClient.fromBytes.e: $e');
// return _instance;
// }
// }
