import 'package:flutter/material.dart';

class LoadingDialog {
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loading 对话框示例'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // 显示loading对话框
              LoadingDialog.showLoadingDialog(context, '加载中...');

              // 模拟异步操作
              Future.delayed(Duration(seconds: 50), () {
                // 隐藏loading对话框
                LoadingDialog.hideLoadingDialog(context);
              });
            },
            child: Text('显示Loading对话框'),
          ),
        ),
      ),
    );
  }
}
