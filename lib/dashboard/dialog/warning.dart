import 'package:flutter/material.dart';

Future<void> showWarningDialog(BuildContext context, String info) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: const Icon(Icons.warning),
      // title: const Text('警告'),
      content: SizedBox(
        height: 25,
        child: Center(
          child: Text(info),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('确定'),
        ),
      ],
    ),
  );
}