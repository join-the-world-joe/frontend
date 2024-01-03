import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/service/admin/business/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_permission_list_of_condition.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import '../config/config.dart';

Future<int> showPermissionListOfRoleDialog(BuildContext context, Role role) async {
  bool closed = false;
  String from = 'showPermissionListOfRoleDialog';
  int curStage = 0;
  List<Widget> widgetList = [];
  var oriObserve = Runtime.getObserve();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showPermissionListOfRoleDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void fetchPermissionListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchPermissionListOfConditionHandler';
    try {
      var rsp = FetchPermissionListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        print(rsp.getBody().toString());
        var permissionList = PermissionList.fromJson(rsp.getBody());
        widgetList = _buildWidgetList(permissionList);
        curStage++;
        return;
      } else if (rsp.getCode() == Code.accessDenied) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.accessDenied),
        ).then((value) {
          Navigator.pop(context);
        });
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.getCode()}').then((value) {
          Navigator.pop(context);
        });
        return;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void observe(PacketClient packet) {
    var caller = "observe";
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchPermissionListOfConditionRsp) {
        fetchPermissionListOfConditionHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: from,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  Runtime.setObserve(observe);

  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      var caller = 'builder';
      fetchPermissionListOfCondition(
        from: from,
        caller: '$caller.fetchPermissionListOfCondition',
        name: '',
        major: '',
        minor: '',
        userId: 0,
        behavior: 2,
        roleList: RoleList([role]),
      );
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Translator.translate(Language.ok)),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StreamBuilder(
          builder: (context, snap) {
            print('data: ${snap.data}');
            if (snap.data != null) {
              return SizedBox(
                width: 400,
                height: 250,
                child: SingleChildScrollView(
                  child: Column(
                    children: widgetList,
                  ),
                ),
              );
            }
            return const SizedBox(
              width: 400,
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          stream: stream(),
        ),
      );
    },
  ).then((value) {
    closed = true;
    Runtime.setObserve(oriObserve);
  });
  return Code.oK;
}

List<Widget> _buildWidgetList(PermissionList permissionList) {
  List<Widget> widgetList = [];
  List<Widget> chipList = [];
  widgetList.add(Spacing.addVerticalSpace(10));
  widgetList.add(const Divider());
  widgetList.add(
    _buildChip(
      label: Translator.translate(Language.permissionList),
      textColor: Colors.white,
    ),
  );
  widgetList.add(Spacing.addVerticalSpace(10));
  for (var i = 0; i < permissionList.getBody().length; i++) {
    var name = permissionList.getBody()[i].getName();
    var major = permissionList.getBody()[i].getMajor();
    var minor = permissionList.getBody()[i].getMinor();
    chipList.add(
      _buildFilterChip(label: Translator.translate(name), textColor: Colors.white, tooltip: '$major-$minor'),
    );
  }
  widgetList.add(
    SizedBox(
      width: 380,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: chipList,
            ),
          ),
        ],
      ),
    ),
  );
  widgetList.add(const Divider());
  return widgetList;
}

Chip _buildChip({required String label, required Color textColor}) {
  return Chip(
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: TextStyle(
        color: textColor,
      ),
    ),
    backgroundColor: Colors.cyan,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}

Widget _buildFilterChip({required String label, required Color textColor, required String tooltip}) {
  return FilterChip(
    tooltip: tooltip,
    onSelected: (b) {},
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: TextStyle(
        color: textColor,
      ),
    ),
    backgroundColor: Colors.blueGrey,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}
