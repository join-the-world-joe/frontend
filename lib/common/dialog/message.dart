import 'package:flutter/material.dart';

Future<void> showMessageDialog(BuildContext context, String title, String content) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: 25,
        child: Center(
          child: Text(content),
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
