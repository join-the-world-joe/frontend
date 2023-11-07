import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';

Future<int> showRemoveUserDialog(BuildContext context, User user) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认删除?'),
          actions: [
            Column(
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID ：${user.getId()}'),
                    Spacing.addVerticalSpace(20),
                    Text('姓名 ：${user.getName()}'),
                    Spacing.addVerticalSpace(20),
                    Text('手机号 ：${user.getPhoneNumber()}'),
                    Spacing.addVerticalSpace(20),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('确定'),
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
