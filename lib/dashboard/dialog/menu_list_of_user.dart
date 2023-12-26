import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/model/side_menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/common/business/admin/fetch_menu_list_of_condition.dart';

Future<int> showMenuListOfUserDialog(BuildContext context, User user) async {
  bool closed = false;
  String from = 'showMenuListOfUserDialog';
  int curStage = 0;
  List<Widget> widgetList = [];
  var oriObserve = Runtime.getObserve();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showInsertUserDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        // print('showRoleListOfUserDialog.last: $lastStage');
        yield lastStage;
      }
    }
  }

  void fetchMenuListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchMenuListOfConditionHandler';
    try {
      FetchMenuListOfConditionRsp rsp = FetchMenuListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        var menuList = SideMenuList.fromJson(rsp.getBody());
        widgetList = _buildWidgetList(menuList);
        curStage++;
        return;
      } else {
        widgetList.add(Text('获取菜单数据失败'));
        curStage = -1;
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
      widgetList.add(Text('获取菜单数据失败'));
      curStage = -1;
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
        from: from,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchMenuListOfConditionRsp) {
        fetchMenuListOfConditionHandler(major: major, minor: minor, body: body);
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
      fetchMenuListOfCondition(
        from: from,
        caller: '$caller.fetchMenuListOfCondition',
        behavior: 2,
        userId: int.parse(user.getId()),
        roleList: RoleList([]),
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

List<Widget> _buildWidgetList(SideMenuList menuList) {
  List<Widget> widgetList = [];
  if (menuList.getBody().isEmpty) {
    widgetList.add(const Text('没有菜单数据'));
    return widgetList;
  }

  for (var i = 0; i < menuList.getBody().length; i++) {
    widgetList.add(Spacing.addVerticalSpace(10));
    widgetList.add(const Divider());
    widgetList.add(
      _buildChip(label: Translator.translate(menuList.getBody()[i].getTitle()), textColor: Colors.white),
    );
    widgetList.add(Spacing.addVerticalSpace(10));
    List<Widget> chips = [];
    for (var j = 0; j < menuList.getBody()[i].getItemList().length; j++) {
      chips.add(
        _buildFilterChip(
          label: Translator.translate(menuList.getBody()[i].getItemList()[j]),
          textColor: Colors.white,
          tooltip: menuList.getBody()[i].getDescList()[j],
        ),
      );
    }
    widgetList.add(SizedBox(
      width: 380,
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: chips,
            ),
          ),
        ],
      ),
    ));
    widgetList.add(const Divider());
  }
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
