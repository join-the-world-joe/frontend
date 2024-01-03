import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/service/admin/business/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/model/permission_list.dart';
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
          print('Permission.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    print('Permission.setup');
    Cache.setPermissionList(PermissionList([]));
    Runtime.setObserve(observe);
  }

  void fetchPermissionListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = "fetchPermissionListOfConditionHandler";
    try {
      var rsp = FetchPermissionListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Permission.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Cache.setPermissionList(PermissionList.fromJson(rsp.getBody()));
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
        from: Permission.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
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
        from: Permission.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchPermissionListOfConditionRsp) {
        fetchPermissionListOfConditionHandler(major: major, minor: minor, body: body);
        curStage++;
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Permission.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Permission.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  @override
  void dispose() {
    // print('Permission.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('Permission.initState');
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
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.menuOfPermission),
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
                          // if (!Runtime.allow(
                          //   major: int.parse(Major.admin),
                          //   minor: int.parse(Admin.fetchTrackListOfConditionReq),
                          // )) {
                          //   return;
                          // }
                          fetchPermissionListOfCondition(
                            from: Permission.content,
                            caller: '$caller.fetchPermissionListOfCondition',
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
                        onPressed: () {
                          Cache.setPermissionList(PermissionList([]));
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
        DataCell(Text(Translator.translate(permissionList.getBody()[index].getDescription()))),
      ],
    );
  }
}
