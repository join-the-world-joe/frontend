import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';

Future<void> showViewNetworkImageDialog(BuildContext context, String url) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      icon: const Icon(Icons.image),
      content: SizedBox(
        height: 500,
        width: 500,
        child: Center(
          child: Image.network(url),
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