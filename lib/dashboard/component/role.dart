import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/dialog/menu_list_of_role.dart';
import 'package:flutter_framework/dashboard/dialog/permission_list_of_role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/common/business/admin/fetch_role_list_of_condition.dart';

class Role extends StatefulWidget {
  const Role({Key? key}) : super(key: key);

  static String content = 'Role';

  @override
  State createState() => _State();
}

class _State extends State<Role> {
  bool closed = false;
  int curStage = 1;
  final scrollController = ScrollController();
  TextEditingController roleController = TextEditingController(text: '');

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      } else {
        if (!Runtime.getConnectivity()) {
          curStage++;
          return;
        }
      }
    }
  }

  void navigate(String page) {
    if (!closed) {
      closed = true;
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          print('Role.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    // print('Role.setup');
    Cache.setRoleList(RoleList([]));
    Runtime.setObserve(observe);
  }

  void observe(PacketClient packet) {
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Role.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchRoleListOfConditionRsp) {
        fetchRoleListOfConditionHandler(major: major, minor: minor, body: body);
        curStage++;
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Role.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Role.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void fetchRoleListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRoleListOfConditionHandler';
    try {
      FetchRoleListOfConditionRsp rsp = FetchRoleListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Role.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        RoleList roleList = RoleList.fromJson(rsp.getBody());
        Cache.setRoleList(roleList);
        curStage++;
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)} ${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Role.content,
        caller: caller,
        message: 'failure, err: $e',
      );
    }
  }

  @override
  void dispose() {
    // print('Role.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('Role.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var caller = 'build';
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
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
                          // if (!Runtime.allow(
                          //   major: int.parse(Major.admin),
                          //   minor: int.parse(Admin.fetchRoleListOfConditionReq),
                          // )) {
                          //   return;
                          // }
                          var inputName = roleController.text.trim();
                          if (inputName.isNotEmpty) {
                            List<String> roleList = [];
                            roleList.add(inputName);
                            fetchRoleListOfCondition(
                              from: Role.content,
                              caller: '$caller.fetchRoleListOfCondition',
                              userId: 0,
                              behavior: 2,
                              roleNameList: roleList,
                            );
                            return;
                          }
                          fetchRoleListOfCondition(
                            from: Role.content,
                            caller: '$caller.fetchRoleListOfCondition',
                            userId: 0,
                            behavior: 1,
                            roleNameList: [],
                          );
                          return;
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
                          curStage++;
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
                ),
              ],
            );
          },
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
              showPermissionListOfRoleDialog(context, roleList.getBody()[index]);
            },
          ),
        ),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.viewMenuList),
            icon: const Icon(Icons.menu),
            onPressed: () {
              // showMenuListOfUserDialog(context, roleList[index]);
              showMenuListOfRoleDialog(context, roleList.getBody()[index]);
            },
          ),
        ),
        DataCell(Text(Translator.translate(roleList.getBody()[index].getDescription()))),
      ],
    );
  }
}
