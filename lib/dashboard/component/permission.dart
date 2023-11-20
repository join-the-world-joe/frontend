import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
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

class Permission extends StatefulWidget {
  const Permission({Key? key}) : super(key: key);

  static String content = 'Permission';

  @override
  State createState() => _State();
}

class _State extends State<Permission> {
  bool closed = false;
  int curStage = 1;
  final scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController minorController = TextEditingController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('Permission.yeildData.last: $lastStage, cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void fetchPermissionListOfConditionHandler(Map<String, dynamic> body) {
    try {
      FetchPermissionListOfConditionRsp rsp = FetchPermissionListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print('body: ${rsp.body}');
        Cache.setPermissionList(PermissionList.fromJson(rsp.body));
        curStage++;
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("Permission.fetchPermissionListOfConditionHandler failure, $e");
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("Permission.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.fetchPermissionListOfConditionRsp) {
        fetchPermissionListOfConditionHandler(body);
        curStage++;
      } else {
        print("Permission.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Permission.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void navigate(String page) {
    print('Permission.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    print('Permission.setup');
    Cache.setPermissionList(PermissionList([]));
    Runtime.setObserve(observe);
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
        child: StreamBuilder(
          stream: yeildData(),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.permission),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: majorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.major),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: minorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.minor),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!Runtime.allow(
                            major: int.parse(Major.admin),
                            minor: int.parse(Minor.admin.fetchTrackListOfConditionReq),
                          )) {
                            return;
                          }
                          fetchPermissionListOfCondition(
                            behavior: 1,
                            name: nameController.text,
                            major: '',
                            minor: '',
                            userId: 0,
                            roleList: RoleList([]),
                          );
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
                        onPressed: () {},
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
                    header: Text(Translator.translate(Language.permissionList)),
                    columns: [
                      DataColumn(label: Text(Translator.translate(Language.titleOfPermission))),
                      DataColumn(label: Text(Translator.translate(Language.major))),
                      DataColumn(label: Text(Translator.translate(Language.minor))),
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
  List<Widget> widgets = [];
  PermissionList permissionList = Cache.getPermissionList();

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => permissionList.getLength();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(Translator.translate(permissionList.getBody()[index].getName()))),
        DataCell(Text(permissionList.getBody()[index].getMajor())),
        DataCell(Text(permissionList.getBody()[index].getMinor())),
        DataCell(Text(permissionList.getBody()[index].getDescription())),
        // DataCell(Text(trackList.getBody()[index].getMajor())),
        // DataCell(Text(trackList.getBody()[index].getMinor())),
        // DataCell(Text('')),
        // DataCell(Text('')),
        // DataCell(Text('')),
        // DataCell(Text('')),
      ],
    );
  }
}
