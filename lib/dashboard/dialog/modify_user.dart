import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';

Future<int> showModifyUserDialog(BuildContext context, User user,
    RoleList wholeRoleList, RoleList roleList) async {
  int? statusGroup = int.parse(user.getStatus());
  Map<Role, bool> roleStatus = {}; // key: role_name, value: bool
  var _nameController = TextEditingController(text: user.getName());
  var _passwordController = TextEditingController(text: '');
  var _verifiedPasswordController = TextEditingController(text: '');

  for (var i = 0; i < wholeRoleList.getBody().length; i++) {
    roleStatus[wholeRoleList.getBody()[i]] = false;
    for (var j = 0; j < roleList.getBody().length; j++) {
      if (roleList.getBody()[j].getName() ==
          wholeRoleList.getBody()[i].getName()) {
        roleStatus[wholeRoleList.getBody()[i]] = true;
        break;
      }
    }
  }

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('更改用户资料'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {},
            child: const Text('确定'),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: 450,
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: Row(
                        children: [
                          Spacing.addHorizontalSpace(85),
                          const Text('启用'),
                          Radio<int?>(
                            value: 1,
                            groupValue: statusGroup,
                            onChanged: (b) {
                              setState(
                                () {
                                  statusGroup = b;
                                },
                              );
                            },
                          ),
                          Spacing.addHorizontalSpace(50),
                          const Text('停用'),
                          Radio<int?>(
                            value: 0,
                            groupValue: statusGroup,
                            onChanged: (b) {
                              setState(
                                () {
                                  statusGroup = b;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '用户名',
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '密码',
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _verifiedPasswordController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: '确认密码',
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    _buildRoleChip('角色'),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 380,
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: () {
                                List<Widget> widgets = [
                                  const Text('获取用户角色列表失败')
                                ];
                                if (roleStatus.isEmpty) {
                                  return widgets;
                                }
                                widgets = [];
                                roleStatus.forEach(
                                  (key, value) {
                                    widgets.add(
                                      InputChip(
                                        padding: const EdgeInsets.all(8.0),
                                        labelPadding: const EdgeInsets.all(2.0),
                                        selectedColor: Colors.green,
                                        selected: roleStatus[key]!,
                                        onPressed: () {
                                          roleStatus[key] = !roleStatus[key]!;
                                          setState(() {});
                                        },
                                        label: Text(key.getName()),
                                      ),
                                    );
                                  },
                                );
                                return widgets;
                              }(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).then(
    (value) {
      return value;
    },
  );
}

Chip _buildRoleChip(String label) {
  return Chip(
    // avatar: const CircleAvatar(
    //   backgroundColor: Colors.orangeAccent,
    //   child: Text('角色'),
    // ),
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.cyan,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}
