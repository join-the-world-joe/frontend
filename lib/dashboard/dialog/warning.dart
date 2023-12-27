import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';

Future<void> showWarningDialog(BuildContext context, String info) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: const Icon(Icons.warning),
      content: SizedBox(
        height: 25,
        child: Center(
          child: Text(info),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:  Text(Translator.translate(Language.ok)),
        ),
      ],
    ),
  );
}