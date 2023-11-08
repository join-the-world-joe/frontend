import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';

Future<bool> showRemoveUserDialog(BuildContext context, User user) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translator.translate(Language.confirmYourDeletion)),
          actions: [
            Column(
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID ：${user.getId()}'),
                    Spacing.addVerticalSpace(20),
                    Text('${Translator.translate(Language.fName)} ：${user.getName()}'),
                    Spacing.addVerticalSpace(20),
                    Text('${Translator.translate(Language.fPhoneNumber)} ：${user.getPhoneNumber()}'),
                    Spacing.addVerticalSpace(20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(Translator.translate(Language.cancel)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(Translator.translate(Language.confirm)),
                    ),
                    Spacing.addVerticalSpace(50),
                  ],
                ),
              ],
            ),
          ],
        );
      }).then((value) {
    return value;
  });
}
