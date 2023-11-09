import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/business/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/insert_user_record.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';

Future<void> showInsertUserDialog(BuildContext context) async {
  String? _countryCode;
  bool closed = false;
  int curStage = 0;
  List<Widget> widgetList = [];
  RoleList wholeRoleList;
  Map<Role, bool> roleStatus = {};
  RoleList roleList = RoleList([]);
  bool bAccountAlreadyExist = false;
  int status = int.parse('1');

  var oriObserve = Runtime.getObserve();
  var _nameController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _passwordController = TextEditingController();
  var _verifyPasswordController = TextEditingController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('showInsertUserDialog, last: $lastStage, cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void fetchRoleListOfConditionHandler(Map<String, dynamic> body) {
    print('showRoleListOfUserDialog.fetchRoleListOfConditionHandler');
    try {
      FetchRoleListOfConditionRsp rsp = FetchRoleListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print(rsp.body.toString());
        wholeRoleList = RoleList.fromJson(rsp.body['role_list']);
        for (var i = 0; i < wholeRoleList.getBody().length; i++) {
          roleStatus[wholeRoleList.getBody()[i]] = false;
          for (var j = 0; j < roleList.getBody().length; j++) {
            if (roleList.getBody()[j].getName() == wholeRoleList.getBody()[i].getName()) {
              roleStatus[wholeRoleList.getBody()[i]] = true;
              break;
            }
          }
        }
        curStage = 1;
        return;
      } else if (rsp.code == Code.accessDenied) {
        showMessageDialog(context, '温馨提示：', '没有权限.');
        curStage = -1;
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        curStage = -1;
        return;
      }
    } catch (e) {
      print("showRoleListOfUserDialog.fetchRoleListOfConditionHandler failure, $e");
    }
  }

  void insertUserRecordHandler(Map<String, dynamic> body) {
    try {
      InsertUserRecordRsp rsp = InsertUserRecordRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        showMessageDialog(context, '温馨提示：', '插入成功').then(
          (value) {
            Runtime.setObserve(oriObserve);
            Navigator.pop(context, null);
          },
        );
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("insertUserRecordHandler.insertUserRecordHandler failure, $e");
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showInsertUserDialog.observe: major: $major, minor: $minor");
      if (major == Major.backend && minor == Minor.backend.insertUserRecordRsp) {
        insertUserRecordHandler(body);
      }
      if (major == Major.backend && minor == Minor.backend.fetchRoleListOfConditionRsp) {
        fetchRoleListOfConditionHandler(body);
      } else {
        print("showInsertUserDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showInsertUserDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      fetchRoleListOfCondition(
        behavior: 1,
        userId: 0,
        roleNameList: [''],
      );
      return AlertDialog(
        title: Text(Translator.translate(Language.newUser)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              if (_passwordController.text != _verifyPasswordController.text) {
                await showWarningDialog(context, '两次输入的密码不一致');
                return;
              }
              List<String> roleList = () {
                List<String> roleList = [];
                roleStatus.forEach(
                  (key, value) {
                    if (value) {
                      roleList.add(key.getName());
                    }
                  },
                );
                print('selected: $roleList');
                return roleList;
              }();
              insertUserRecord(
                name: _nameController.text,
                phoneNumber: _phoneNumberController.text,
                countryCode: _countryCode ?? '86',
                status: status,
                password: Runtime.rsa.encrypt(_passwordController.text),
                roleList: roleList,
              );
            },
            child: Text(Translator.translate(Language.confirm)),
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
                          Text(Translator.translate(Language.enable)),
                          Radio<int?>(
                              value: 1,
                              groupValue: status,
                              onChanged: (b) {
                                setState(() {
                                  status = b!;
                                });
                                // print("status: $b");
                              }),
                          Spacing.addHorizontalSpace(50),
                          Text(Translator.translate(Language.disable)),
                          Radio<int?>(
                            value: 2,
                            groupValue: status,
                            onChanged: (b) {
                              setState(() {
                                status = b!;
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
                        hint: Text(
                          Translator.translate(Language.fCountryCode),
                        ),
                        isExpanded: true,
                        value: _countryCode,
                        items: [
                          DropdownMenuItem<String>(
                            value: '86',
                            child: Text(Translator.translate(Language.china)),
                          ),
                          DropdownMenuItem<String>(
                            value: '63',
                            child: Text(Translator.translate(Language.philipine)),
                          ),
                        ],
                        onChanged: (countryCode) {
                          _countryCode = countryCode ?? '';
                          setState(() {});
                        },
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          // border: UnderlineInputBorder(),
                          labelText: Translator.translate(Language.fPhoneNumber),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          // border: UnderlineInputBorder(),
                          labelText: Translator.translate(Language.fName),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          // border: UnderlineInputBorder(),
                          labelText: Translator.translate(Language.password),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: true,
                        controller: _verifyPasswordController,
                        decoration: InputDecoration(
                          // border: UnderlineInputBorder(),
                          labelText: Translator.translate(Language.confirmPassword),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    _buildRoleChip(Translator.translate(Language.fRole)),
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
                                List<Widget> widgets = [const Text('获取用户角色列表失败')];
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
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

List<Widget> _buildWidgetList() {

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
