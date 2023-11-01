import 'package:flutter/material.dart';

class FutureBuilderTemplate extends StatefulWidget {
  const FutureBuilderTemplate({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<FutureBuilderTemplate> {
  // declare all attributes here; 此处声明类属性
  // the stage of this page; from 1 to ...; 页面状态, 从1开始, 至...
  int lastStage = 0;
  int curStage = 0;
  bool bindCallback = false; // set true if bind callback; 当页面绑定callback时, 设为真

  // call refresh to render or re-render this page
  void refresh() {
    // 调用render渲染页面
    setState(() {});
  }

  // put all the stuff pre init state here
  void setup() {
    // 此处放置初始化前的逻辑
  }

  // fetch the data of this page;
  Future<String?> fetch() async {
    // 此处放置获取本页数据逻辑
    return '';
  }

  // put all the stuff about checking progress and triggering the render logic
  void progress() async {
    // 此处检查程序进度 和 通知渲染界面

    print('获取本地缓存资料');
    await Future.delayed(const Duration(seconds: 4));

    print('尝试授权');
    curStage = 1;
    refresh();
    await Future.delayed(const Duration(seconds: 3));

    print('获得权限');
    curStage = 2;
    refresh();
    await Future.delayed(const Duration(seconds: 3));

    return;
  }

  // check all the response code in callback and update the progress indicator
  void callback(int code) {
    // 此处检查response并更新程序进度
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
    return FutureBuilder(
      future: fetch(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Text('no data yet');
        }
        // return const Text('put render logic here, maybe call multiple times to render the whole page');
        if (curStage == 0) {
          print('curStage == 0');
          return const Center(child: CircularProgressIndicator());
        } else if (curStage == 1) {
          lastStage = curStage;
          print('curStage == 1');
          return const Text('尝试授权');
        } else if(curStage == 2) {
          lastStage = curStage;
          print('curStage == 2');
          return const Text('获得权限');
        } else {
          print('curStage == default, curStage: $curStage, lastStage: $lastStage');
          return const Text('Default');
        }
      },
    );
  }
}
