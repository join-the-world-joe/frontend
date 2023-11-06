import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/backend/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/common/business/backend/fetch_user_list_of_condition.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/dialog/role_list_of_user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
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
import '../setup.dart';

class User extends StatefulWidget {
  const User({Key? key}) : super(key: key);

  static String content = 'User';

  @override
  State createState() => _State();
}

class _State extends State<User> {
  final nameControl = TextEditingController();
  final roleControl = TextEditingController();
  final phoneNumberControl = TextEditingController();

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("User.observe: major: $major, minor: $minor");
    try {
      if (major == Major.backend &&
          minor == Minor.backend.fetchUserListOfConditionRsp) {
        fetchUserListOfConditionHandler(body);
      } else if (major == Major.backend &&
          minor == Minor.backend.fetchRoleListOfConditionRsp) {
        fetchRoleListOfConditionHandler(body);
      } else {
        print("User.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('User.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void fetchRoleListOfConditionHandler(Map<String, dynamic> body) {
    print('User.fetchRoleListOfConditionHandler');
    try {
      FetchRoleListOfConditionRsp rsp =
          FetchRoleListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print(rsp.body.toString());
        refresh();
        showRoleListOfUserDialog(context, ['Manager', 'Worker', 'Sales']);
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
      print("User.fetchRoleListOfConditionHandler failure, $e");
    }
  }

  void fetchUserListOfConditionHandler(Map<String, dynamic> body) {
    print('User.fetchUserListOfConditionHandler');
    try {
      FetchUserListOfConditionRsp rsp =
          FetchUserListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        Cache.setUserList([]);
        print('body: ${rsp.body.toString()}');
        print(rsp.body);
        // var body = rsp.body as Map<String, List<dynamic>>;
        var userList = rsp.body['user_list'] as List<dynamic>;
        userList.forEach(
          (e) {
            Cache.userList.add(
              usr.User(
                  id: e['id'],
                  name: e['name'],
                  account: e['account'],
                  email: e['email'],
                  department: e['department'],
                  countryCode: e['country_code'],
                  phoneNumber: e['phone_number'],
                  status: e['status'],
                  createdAt: e['created_at']),
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
    print('User.refresh');
    setState(() {});
  }

  void navigate(String page) {
    print('User.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    print('User.setup');
    Cache.setUserList([]);
    Runtime.setObserve(observe);
  }

  void progress() async {
    print('User.progress');
    return;
  }

  @override
  void dispose() {
    print('User.dispose');
    super.dispose();
  }

  void debug() async {
    print('User.debug');
  }

  @override
  void initState() {
    print('User.initState');
    setup();
    progress();
    debug();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView(
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
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '手机号',
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      controller: nameControl,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '姓名',
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      controller: roleControl,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '角色',
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
                        fetchUserListOfCondition(
                            name: nameControl.text,
                            role: roleControl.text,
                            phoneNumber: phoneNumberControl.text);
                        refresh();
                      },
                      child: const Text(
                        '查询',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        phoneNumberControl.text = '18629300170';
                        refresh();
                      },
                      child: const Text(
                        '重置',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              Spacing.addVerticalSpace(20),
              PaginatedDataTable(
                actions: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: () async {},
                    label: const Text(
                      '新增用户',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
                source: Source(context),
                header: const Text('用户列表'),
                columns: const [
                  DataColumn(label: Text('手机号')),
                  DataColumn(label: Text('姓名')),
                  DataColumn(label: Text('状态')),
                  DataColumn(label: Text('角色列表')),
                  DataColumn(label: Text('创建时间')),
                  DataColumn(label: Text('     操作')),
                ],
                columnSpacing: 60,
                horizontalMargin: 10,
                rowsPerPage: 5,
                showCheckboxColumn: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Source extends DataTableSource {
  BuildContext context;
  List<Widget> widgets = [];
  final List<usr.User> _data = Cache.getUserList();

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(_data[index].phoneNumber)),
        DataCell(Text(_data[index].name)),
        DataCell(_data[index].status == '1'
            ? const Icon(Icons.done, color: Colors.lightGreen)
            : const Icon(Icons.close)),
        DataCell(
          IconButton(
            tooltip: "查看角色列表",
            icon: const Icon(Icons.people_alt_rounded),
            onPressed: () {
              fetchRoleListOfCondition(
                userIdList: [int.parse(_data[index].id)],
                userName: '',
                phoneNumber: '',
              );
            },
          ),
        ),
        DataCell(Text(_data[index].createdAt)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.verified_user_outlined),
                tooltip: '查看权限',
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.menu),
                tooltip: '查看菜单',
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.table_view_sharp),
                tooltip: '查看数据域',
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: '更新资料',
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: '删除用户',
                onPressed: () async {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
