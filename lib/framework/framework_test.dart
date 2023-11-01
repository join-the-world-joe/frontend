import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'routing.dart';
import 'message_hook.dart';
import 'dart:io';
import 'package:flutter_framework/framework/header.dart';
import 'package:flutter_framework/framework/packet_client.dart';

class FrameworkTest extends StatefulWidget {
  const FrameworkTest({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<FrameworkTest> {
  // declare all attributes here; 此处声明类属性
  // the stage of this page; from 1 to ...; 页面状态, 从1开始, 至...
  bool bindCallback = false; // set true if bind callback; 当页面绑定callback时, 设为真
  String major = '1';
  String minor = '2';
  static MessageHook hook = MessageHook();
  late BuildContext ctx;

  // pull navigation logic here
  void navigate(String page) {
    // 此处放置页面跳转逻辑
    if (bindCallback) {
      hook.unRegister(
        Routing.key(major: major, minor: minor),
      );
      hook.unRegister(
        Routing.key(major: major, minor: minor),
      );
      hook.unRegister(
        Routing.key(major: major, minor: minor),
      );
    }
  }

  // call refresh to render or re-render this page
  void refresh() {
    // 调用render渲染页面
    setState(() {});
  }

  // put all the stuff pre init state here
  void setup() {
    hook.register(Routing.key(major: major, minor: minor), handler);
    hook.register(Routing.key(major: major, minor: minor), handler);
    hook.register(Routing.key(major: major, minor: minor), handler);
  }

  // fetch the data of this page;
  Future<String?> fetch() async {
    // 此处放置获取本页数据逻辑

    return '';
  }

  // put all the stuff about checking progress and triggering the render logic
  void progress() async {
    return;
  }

  // check all the response code in callback and update the progress indicator
  void callback1(int code) async {
    // 此处检查response并更新程序进度
    await Future.delayed(Duration(seconds: 1));
    print('callback1: $code');
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  void callback2(int code) {
    // 此处检查response并更新程序进度
    _showMyDialog(ctx);
    print('callback2: $code');
    return;
  }

  void callback3(int code) {
    // 此处检查response并更新程序进度
    print('callback3: $code');
    return;
  }

  @override
  void dispose() {
    // print('Loading.dispose');
    super.dispose();
  }

  @override
  void initState() {
    setup();
    progress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        ctx = context;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print('on press');
              var header = Header.build(major: major, minor: minor);
              Map<String, dynamic> body = {"k1": "v1", "k2": "v2"};
              var packet = PacketClient(header: header, body: body);
              hook.observe(packet);
            },
          ),
        );
      },
    );
  }
}

int handler(Map<String, dynamic> body) {
  try {
    print('body: $body');
    return Code.oK;
  } catch (e) {
    return Code.internalError;
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
