import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/common/business/admin/fetch_role_list_of_condition.dart';

Future<int> showRoleListOfUserDialog(BuildContext context, User user) async {
  bool closed = false;
  int curStage = 0;
  List<Widget> widgetList = [];
  var oriObserve = Runtime.getObserve();
  String from = 'showRoleListOfUserDialog';

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showRoleListOfUserDialog, last: $lastStage, cur: $curStage');
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
      if (rsp.getCode() == Code.oK) {
        RoleList roleList = RoleList.fromJson(rsp.getBody());
        widgetList = _buildWidgetList(roleList);
        curStage++;
        return;
      } else if (rsp.getCode() == Code.accessDenied) {
        showMessageDialog(context, '温馨提示：', '没有权限.').then(
          (value) {
            Navigator.pop(context);
          },
        );
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.getCode()}').then(
          (value) {
            Navigator.pop(context);
          },
        );
        return;
      }
    } catch (e) {
      print("showRoleListOfUserDialog.fetchRoleListOfConditionHandler failure, $e");
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showRoleListOfUserDialog.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Admin.fetchRoleListOfConditionRsp) {
        fetchRoleListOfConditionHandler(body);
      } else {
        print("showRoleListOfUserDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showRoleListOfUserDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  Runtime.setObserve(observe);

  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      fetchRoleListOfCondition(
        from: from,
        behavior: 2,
        userId: int.parse(user.getId()),
        roleNameList: [''],
      );
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(Translator.translate(Language.ok)),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StreamBuilder(
          builder: (context, snap) {
            print('data: ${snap.data}');
            if (snap.data != null) {
              print('data: ${snap.data}');
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
          stream: yeildData(),
        ),
      );
    },
  ).then((value) {
    closed = true;
    Runtime.setObserve(oriObserve);
  });
  return Code.oK;
}

List<Widget> _buildWidgetList(RoleList roleList) {
  List<Widget> widgetList = [];
  List<Widget> chipList = [];
  widgetList.add(Spacing.addVerticalSpace(10));
  widgetList.add(const Divider());
  widgetList.add(
    _buildChip(
      label: Translator.translate(Language.roleList),
      textColor: Colors.white,
    ),
  );
  widgetList.add(Spacing.addVerticalSpace(10));
  for (var i = 0; i < roleList.getBody().length; i++) {
    var name = roleList.getBody()[i].getName();
    var desc = roleList.getBody()[i].getDescription();
    chipList.add(_buildFilterChip(label: Translator.translate(name), textColor: Colors.white, tooltip: Translator.translate(desc)));
  }
  widgetList.add(
    SizedBox(
      width: 380,
      child: Row(
        children: [
          if (roleList.getBody().isEmpty) Text('未分配角色'),
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
    // avatar: const CircleAvatar(
    //   backgroundColor: Colors.orangeAccent,
    //   child: Text('角色'),
    // ),
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
