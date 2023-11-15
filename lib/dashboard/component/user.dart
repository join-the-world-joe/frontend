import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/check_permission.dart';
import 'package:flutter_framework/dashboard/business/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/fetch_user_list_of_condition.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/dashboard/business/soft_delete_user_recode.dart';
import 'package:flutter_framework/dashboard/component/permission.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/dialog/insert_user.dart';
import 'package:flutter_framework/dashboard/dialog/menu_list_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/update_user.dart';
import 'package:flutter_framework/dashboard/dialog/permission_list_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/remove_user.dart';
import 'package:flutter_framework/dashboard/dialog/role_list_of_user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart' as usr;
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import '../responsive.dart';
import '../config/config.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import '../setup.dart';
import 'package:flutter_framework/dashboard/business/insert_user_record.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  static String content = 'User';

  @override
  State createState() => _State();
}

class _State extends State<User> {
  bool closed = false;
  int curStage = 0;
  bool hasFetchPermissionListOfCondition = false;
  bool hasFetchMenuListOfCondition = false;
  final nameControl = TextEditingController();
  final roleControl = TextEditingController();
  final phoneNumberControl = TextEditingController();
  final scrollController = ScrollController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('User.yeildData.last: $lastStage, cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        // print('showPermissionListOfUserDialog.last: $lastStage');
        yield lastStage;
      }
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      // print("User.observe: major: $major, minor: $minor");
      if (major == Major.backend && minor == Minor.backend.fetchUserListOfConditionRsp) {
        fetchUserListOfConditionHandler(body);
      } else if (major == Major.backend && minor == Minor.backend.checkPermissionRsp) {
        checkPermissionHandler(body);
      } else {
        print("User.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('User.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void checkPermissionHandler(Map<String, dynamic> body) {
    print('User.checkPermissionHandler');
    try {
      CheckPermissionRsp rsp = CheckPermissionRsp.fromJson(body);
      if (rsp.getMinor() == int.parse(Minor.backend.fetchPermissionListOfConditionReq)) {
        hasFetchPermissionListOfCondition = rsp.getCode() == Code.oK ? true : false;
      }
      if (rsp.getMinor() == int.parse(Minor.backend.fetchMenuListOfConditionReq)) {
        hasFetchMenuListOfCondition = rsp.getCode() == Code.oK ? true : false;
      }
      curStage++;
      return;
    } catch (e) {
      print("User.checkPermissionHandler failure, $e");
      return;
    }
  }

  void fetchUserListOfConditionHandler(Map<String, dynamic> body) {
    // print('User.fetchUserListOfConditionHandler');
    try {
      FetchUserListOfConditionRsp rsp = FetchUserListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        Cache.setUserList([]);
        // print('body: ${rsp.body.toString()}');
        // print(rsp.body);
        var userList = rsp.body['user_list'] as List<dynamic>;
        userList.forEach(
          (e) {
            Cache.userList.add(
              usr.User(e['id'], e['name'], e['account'], e['email'], e['department'], e['country_code'], e['phone_number'], e['status'], e['created_at']),
            );
          },
        );
        refresh();
        return;
      } else if (rsp.code == Code.accessDenied) {
        showMessageDialog(context, '温馨提示：', '没有权限.');
        refresh();
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("User.fetchUserListOfConditionHandler failure, $e");
    }
  }

  void refresh() {
    // print('User.refresh');
    setState(() {});
  }

  void navigate(String page) {
    print('User.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    // print('User.setup');
    Cache.setUserList([]);
    Runtime.setObserve(observe);
  }

  void progress() async {
    // print('User.progress');
    return;
  }

  @override
  void dispose() {
    // print('User.dispose');
    closed = true;
    super.dispose();
  }

  @override
  void initState() {
    // print('User.initState');
    setup();
    progress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkPermission(major: Major.backend, minor: Minor.backend.fetchPermissionListOfConditionReq);
    checkPermission(major: Major.backend, minor: Minor.backend.fetchMenuListOfConditionReq);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: yeildData(),
          builder: (context, snap) {
            if (curStage > 0) {
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 110,
                        child: TextFormField(
                          controller: phoneNumberControl,
                          decoration: InputDecoration(
                            // border: const UnderlineInputBorder(),
                            labelText: Translator.translate(Language.fPhoneNumber),
                          ),
                        ),
                      ),
                      Spacing.addHorizontalSpace(20),
                      SizedBox(
                        width: 110,
                        child: TextFormField(
                          controller: nameControl,
                          decoration: InputDecoration(
                            // border: const UnderlineInputBorder(),
                            labelText: Translator.translate(Language.fName),
                          ),
                        ),
                      ),
                      Spacing.addHorizontalSpace(20),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Cache.setUserList([]);
                            // print('name: ${nameControl.text}');
                            if (!Runtime.allow(
                              major: int.parse(Major.backend),
                              minor: int.parse(Minor.backend.fetchUserListOfConditionReq),
                            )) {
                              return;
                            }
                            if (nameControl.text.isEmpty && phoneNumberControl.text.isEmpty) {
                              fetchUserListOfCondition(
                                behavior: 1,
                                name: '',
                                phoneNumber: '',
                                userId: 0,
                              );
                            } else {
                              fetchUserListOfCondition(
                                behavior: 2,
                                name: nameControl.text,
                                phoneNumber: phoneNumberControl.text,
                                userId: 0,
                              );
                            }
                          },
                          child: Text(
                            Translator.translate(Language.search),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      Spacing.addHorizontalSpace(20),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            phoneNumberControl.text = '';
                            nameControl.text = '';
                            Cache.setUserList([]);
                            refresh();
                          },
                          child: Text(
                            Translator.translate(Language.reset),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacing.addVerticalSpace(20),
                  Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: PaginatedDataTable(
                      controller: scrollController,
                      actions: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            showInsertUserDialog(context);
                          },
                          label: Text(
                            Translator.translate(Language.newUser),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                      source: Source(context, hasFetchPermissionListOfCondition, hasFetchMenuListOfCondition),
                      header: Text(Translator.translate(Language.userList)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.fPhoneNumber))),
                        DataColumn(label: Text(Translator.translate(Language.fName))),
                        DataColumn(label: Text(Translator.translate(Language.fStatus))),
                        DataColumn(label: Text(Translator.translate(Language.fRole))),
                        if (hasFetchPermissionListOfCondition) DataColumn(label: Text(Translator.translate(Language.fPermission))),
                        if (hasFetchMenuListOfCondition) DataColumn(label: Text(Translator.translate(Language.tMenu))),
                        // DataColumn(label: Text('字段列表')),
                        DataColumn(label: Text(Translator.translate(Language.fCreatedAt))),
                        DataColumn(label: Text(Translator.translate(Language.operation))),
                      ],
                      columnSpacing: 60,
                      horizontalMargin: 10,
                      rowsPerPage: 5,
                      showCheckboxColumn: false,
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class Source extends DataTableSource {
  BuildContext context;
  List<Widget> widgets = [];
  final List<usr.User> _data = Cache.getUserList();
  bool hasFetchPermissionListOfCondition;
  bool hasFetchMenuListOfCondition;

  Source(this.context, this.hasFetchPermissionListOfCondition, this.hasFetchMenuListOfCondition);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => getLength();

  int getLength() {
    // print('length: ${_data.length}');
    return _data.length;
  }

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {
        // print('selected: $selected');
      },
      cells: [
        DataCell(Text(_data[index].getPhoneNumber())),
        DataCell(Text(_data[index].getName())),
        DataCell(_data[index].getStatus() == '1' ? const Icon(Icons.done, color: Colors.lightGreen) : const Icon(Icons.close)),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.viewRoleList),
            icon: const Icon(Icons.people_alt_rounded),
            onPressed: () {
              showRoleListOfUserDialog(context, _data[index]);
            },
          ),
        ),
        if (hasFetchPermissionListOfCondition)
          DataCell(
            IconButton(
              tooltip: Translator.translate(Language.viewPermissionList),
              icon: const Icon(Icons.verified_user_outlined),
              onPressed: () {
                showPermissionListOfUserDialog(context, _data[index]);
              },
            ),
          ),
        if (hasFetchMenuListOfCondition)
          DataCell(
            IconButton(
              tooltip: Translator.translate(Language.viewMenuList),
              icon: const Icon(Icons.menu),
              onPressed: () {
                showMenuListOfUserDialog(context, _data[index]);
              },
            ),
          ),
        DataCell(Text(_data[index].getCreatedAt())),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: Translator.translate(Language.update),
                onPressed: () async {
                  showUpdateUserDialog(context, _data[index]);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: Translator.translate(Language.remove),
                onPressed: () async {
                  await showRemoveUserDialog(context, _data[index]).then(
                    (value) => () {
                      // print('value: $value');
                      if (value) {
                        _data.removeAt(index);
                        notifyListeners();
                      }
                    }(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
