import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
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

class Role extends StatefulWidget {
  const Role({Key? key}) : super(key: key);

  static String content = 'Role';

  @override
  State createState() => _State();
}

class _State extends State<Role> {
  bool closed = false;
  int curStage = 1;
  TextEditingController roleController = TextEditingController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('Track.yeildData.last: $lastStage, cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void navigate(String page) {
    print('Role.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    print('Role.setup');
  }

  void progress() async {
    print('Role.progress');
    return;
  }

  @override
  void dispose() {
    print('Role.dispose');
    super.dispose();
  }

  void debug() async {
    print('Role.debug');
  }

  @override
  void initState() {
    print('Role.initState');
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
                      controller: roleController,
                      decoration: InputDecoration(
                        labelText: Translator.translate(Language.titleOfRole),
                      ),
                    ),
                  ),
                  Spacing.addHorizontalSpace(20),
                  SizedBox(
                    height: 30,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      child: Text(
                        Translator.translate(Language.titleOfSearch),
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
                        Cache.setRoleList(RoleList([]));
                        roleController.text = '';
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
              PaginatedDataTable(
                source: Source(context),
                header: Text(Translator.translate(Language.roleList)),
                columns: [
                  DataColumn(label: Text(Translator.translate(Language.titleOfRole))),
                  DataColumn(label: Text(Translator.translate(Language.rankOfRole))),
                  DataColumn(label: Text(Translator.translate(Language.departmentOfRole))),
                  DataColumn(label: Text(Translator.translate(Language.permissionList))),
                  DataColumn(label: Text(Translator.translate(Language.menuList))),
                  DataColumn(label: Text(Translator.translate(Language.description))),
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
  RoleList roleList = Cache.getRoleList();

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => roleList.getLength();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(Translator.translate(roleList.getBody()[index].getName()))),
        DataCell(Text(roleList.getBody()[index].getRank().toString())),
        DataCell(Text(Translator.translate(roleList.getBody()[index].getDepartment()))),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.viewPermissionList),
            icon: const Icon(Icons.verified_user_outlined),
            onPressed: () {
              // showPermissionListOfUserDialog(context, roleList[index]);
            },
          ),
        ),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.viewMenuList),
            icon: const Icon(Icons.menu),
            onPressed: () {
              // showMenuListOfUserDialog(context, roleList[index]);
            },
          ),
        ),
        DataCell(Text(Translator.translate(roleList.getBody()[index].getDescription()))),
      ],
    );
  }
}
