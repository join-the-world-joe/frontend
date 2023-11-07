import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';

Future<int> showInsertUserDialog(
    BuildContext context, RoleList wholeRoleList, RoleList roleList) async {
  String? _method;
  var _nameController = TextEditingController();
  var _accountController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _passwordController = TextEditingController();
  var _verifyPasswordController = TextEditingController();

  bool bAccountAlreadyExist = false;
  int? statusGroup = int.parse('1');
  Map<Role, bool> roleStatus = {}; // key: role_name, value: bool

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
          title: const Text('新增用户'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                if (_passwordController.text !=
                    _verifyPasswordController.text) {
                  await showWarningDialog(context, '两次输入的密码不一致');
                  return;
                }
                var roleList = () {
                  List<Role> roleList = [];
                  roleStatus.forEach(
                    (key, value) {
                      if (value) {
                        roleList.add(key);
                      }
                    },
                  );
                  return roleList;
                }();
              },
              child: const Text('确定'),
            ),
            // Spacing.AddVerticalSpace(50),
          ],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: 450,
                height: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                  setState(() {
                                    statusGroup = b;
                                  });
                                  // print("status: $b");
                                }),
                            Spacing.addHorizontalSpace(50),
                            const Text('停用'),
                            Radio<int?>(
                              value: 0,
                              groupValue: statusGroup,
                              onChanged: (b) {
                                setState(() {
                                  statusGroup = b;
                                });
                                // print("status: $b");
                              },
                            ),
                          ],
                        ),
                      ),
                      Spacing.addVerticalSpace(10),
                      SizedBox(
                        width: 350,
                        child: DropdownButtonFormField<String>(
                          hint: const Text(
                            '国家地区码',
                          ),
                          isExpanded: true,
                          value: _method,
                          items: const [
                            DropdownMenuItem<String>(
                              value: '86',
                              child: Text('中国'),
                            ),
                            DropdownMenuItem<String>(
                              value: '63',
                              child: Text('菲律宾'),
                            ),
                          ],
                          onChanged: (method) {
                            _method = method ?? '';
                            setState(() {});
                          },
                        ),
                      ),
                      Spacing.addVerticalSpace(10),
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: '手机号',
                          ),
                        ),
                      ),
                      Spacing.addVerticalSpace(10),
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: '姓名',
                          ),
                        ),
                      ),
                      Spacing.addVerticalSpace(10),
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                          obscureText: true,
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
                          obscureText: true,
                          controller: _verifyPasswordController,
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
                            // const Text('角色 : '),
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
                                          labelPadding:
                                              const EdgeInsets.all(2.0),
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
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }).then(
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
