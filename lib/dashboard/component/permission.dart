import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/backend/fetch_menu_list_of_role.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
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

class Permission extends StatefulWidget {
  const Permission({Key? key}) : super(key: key);

  static String content = 'Permission';

  @override
  State createState() => _State();
}

class _State extends State<Permission> {
  void navigate(String page) {
    print('Permission.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    print('Permission.setup');
  }

  void progress() async {
    print('Permission.progress');
    return;
  }

  @override
  void dispose() {
    print('Permission.dispose');
    super.dispose();
  }

  void debug() async {
    print('Permission.debug');
  }

  @override
  void initState() {
    print('Permission.initState');
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
                      // controller: _accountController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '权限',
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      // controller: _accountController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '主业务号',
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      // controller: _accountController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: '次业务号',
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      // controller: _accountController,
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
                      onPressed: () {},
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
                      onPressed: () {},
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
                source: Source(context),
                header: const Text('权限列表'),
                columns: const [
                  DataColumn(label: Text('权限')),
                  DataColumn(label: Text('主业务号')),
                  DataColumn(label: Text('次业务号')),
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
  final List<User> _data = [];

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
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(
          FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              return const CircularProgressIndicator();
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                tooltip: '查看用户菜单',
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                tooltip: '查看用户详情',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: '修改用户资料',
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
