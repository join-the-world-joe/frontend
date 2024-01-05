import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/service/admin/business/fetch_user_list_of_condition.dart';
import 'package:flutter_framework/common/service/admin/dialog/soft_delete_records_of_user.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_user_list_of_condition.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/service/admin/dialog/insert_record_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/menu_list_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/permission_list_of_user.dart';
import 'package:flutter_framework/dashboard/dialog/role_list_of_user.dart';
import 'package:flutter_framework/common/service/admin/dialog/update_record_of_user.dart';
import 'package:flutter_framework/dashboard/model/user_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/common/service/admin/protocol/check_permission.dart';
import 'package:flutter_framework/common/service/admin/business/check_permission.dart';

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
  bool hasInsertUserRecord = false;
  bool hasSoftDeleteUserRecord = false;
  final nameControl = TextEditingController();
  final roleControl = TextEditingController();
  final phoneNumberControl = TextEditingController();
  final scrollController = ScrollController();

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
          print('User.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    var caller = 'setup';
    // print('User.setup');
    Cache.setUserList(UserList.construct(userList: []));
    Runtime.setObserve(observe);
    checkPermission(
      from: User.content,
      caller: caller,
      major: Major.admin,
      minor: Admin.fetchPermissionListOfConditionReq,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      checkPermission(
        from: User.content,
        caller: caller,
        major: Major.admin,
        minor: Admin.fetchMenuListOfConditionReq,
      );
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      checkPermission(
        from: User.content,
        caller: caller,
        major: Major.admin,
        minor: Admin.insertRecordOfUserReq,
      );
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      checkPermission(
        from: User.content,
        caller: caller,
        major: Major.admin,
        minor: Admin.softDeleteRecordOfUserReq,
      );
    });
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
        from: User.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchUserListOfConditionRsp) {
        fetchUserListOfConditionHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.checkPermissionRsp) {
        checkPermissionHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: User.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: User.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void checkPermissionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'checkPermissionHandler';
    try {
      CheckPermissionRsp rsp = CheckPermissionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: User.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getMinor() == int.parse(Admin.fetchPermissionListOfConditionReq)) {
        hasFetchPermissionListOfCondition = rsp.getCode() == Code.oK ? true : false;
      } else if (rsp.getMinor() == int.parse(Admin.fetchMenuListOfConditionReq)) {
        hasFetchMenuListOfCondition = rsp.getCode() == Code.oK ? true : false;
      } else if (rsp.getMinor() == int.parse(Admin.insertRecordOfUserReq)) {
        hasInsertUserRecord = rsp.getCode() == Code.oK ? true : false;
      } else if (rsp.getMinor() == int.parse(Admin.softDeleteRecordOfUserReq)) {
        hasSoftDeleteUserRecord = rsp.getCode() == Code.oK ? true : false;
      }
      curStage++;
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: User.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void fetchUserListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchUserListOfConditionHandler';
    try {
      var rsp = FetchUserListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: User.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Cache.setUserList(UserList.fromJson(rsp.getBody()));
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
        from: User.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void refresh() {
    // print('User.refresh');
    setState(() {});
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
                            Cache.setUserList(UserList.construct(userList: []));
                            // print('name: ${nameControl.text}');
                            // if (!Runtime.allow(
                            //   major: int.parse(Major.admin),
                            //   minor: int.parse(Admin.fetchUserListOfConditionReq),
                            // )) {
                            //   return;
                            // }
                            if (nameControl.text.isEmpty && phoneNumberControl.text.isEmpty) {
                              fetchUserListOfCondition(
                                from: User.content,
                                caller: '$caller.fetchUserListOfCondition',
                                behavior: 1,
                                name: '',
                                phoneNumber: '',
                                userId: 0,
                              );
                            } else {
                              fetchUserListOfCondition(
                                from: User.content,
                                caller: '$caller.fetchUserListOfCondition',
                                behavior: 2,
                                name: nameControl.text,
                                phoneNumber: phoneNumberControl.text,
                                userId: 0,
                              );
                            }
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
                            phoneNumberControl.text = '';
                            nameControl.text = '';
                            Cache.setUserList(UserList.construct(userList: []));
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
                        if (hasInsertUserRecord)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              showInsertRecordOfUserDialog(context);
                            },
                            label: Text(
                              Translator.translate(Language.newUser),
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                      ],
                      source: Source(
                        context,
                        hasFetchPermissionListOfCondition,
                        hasFetchMenuListOfCondition,
                        hasSoftDeleteUserRecord,
                      ),
                      header: Text(Translator.translate(Language.userList)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.fPhoneNumber))),
                        DataColumn(label: Text(Translator.translate(Language.fName))),
                        DataColumn(label: Text(Translator.translate(Language.fStatus))),
                        DataColumn(label: Text(Translator.translate(Language.titleOfRole))),
                        if (hasFetchPermissionListOfCondition) DataColumn(label: Text(Translator.translate(Language.titleOfPermission))),
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
  UserList userList = Cache.getUserList();
  bool hasFetchPermissionListOfCondition;
  bool hasFetchMenuListOfCondition;
  bool hasSoftDeleteUserRecord;

  Source(
    this.context,
    this.hasFetchPermissionListOfCondition,
    this.hasFetchMenuListOfCondition,
    this.hasSoftDeleteUserRecord,
  );

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userList.getLength();

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
        DataCell(
          Text(userList.getBody()[index].getPhoneNumber()),
          onTap: () {
            Clipboard.setData(ClipboardData(text: userList.getBody()[index].getPhoneNumber()));
          },
        ),
        DataCell(
          Text(userList.getBody()[index].getName()),
          onTap: () {
            Clipboard.setData(ClipboardData(text: userList.getBody()[index].getName()));
          },
        ),
        DataCell(userList.getBody()[index].getStatus() == '1' ? const Icon(Icons.done, color: Colors.lightGreen) : const Icon(Icons.close)),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.viewRoleList),
            icon: const Icon(Icons.people_alt_rounded),
            onPressed: () {
              showRoleListOfUserDialog(context, userList.getBody()[index]);
            },
          ),
        ),
        if (hasFetchPermissionListOfCondition)
          DataCell(
            IconButton(
              tooltip: Translator.translate(Language.viewPermissionList),
              icon: const Icon(Icons.verified_user_outlined),
              onPressed: () {
                showPermissionListOfUserDialog(context, userList.getBody()[index]);
              },
            ),
          ),
        if (hasFetchMenuListOfCondition)
          DataCell(
            IconButton(
              tooltip: Translator.translate(Language.viewMenuList),
              icon: const Icon(Icons.menu),
              onPressed: () {
                showMenuListOfUserDialog(context, userList.getBody()[index]);
              },
            ),
          ),
        DataCell(
          Text(userList.getBody()[index].getCreatedAt()),
          onTap: () {
            Clipboard.setData(ClipboardData(text: userList.getBody()[index].getCreatedAt()));
          },
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: Translator.translate(Language.update),
                onPressed: () async {
                  showUpdateRecordOfUserDialog(context, userList.getBody()[index]);
                },
              ),
              if (hasSoftDeleteUserRecord)
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: Translator.translate(Language.remove),
                  onPressed: () async {
                    await showSoftDeleteRecordsOfUserDialog(context, userList.getBody()[index]).then(
                      (value) => () {
                        // print('value: $value');
                        if (value) {
                          userList.getBody().removeAt(index);
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
