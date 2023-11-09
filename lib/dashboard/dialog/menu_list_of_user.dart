import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/dashboard/component/menu.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';

Future<int> showMenuListOfUserDialog(BuildContext context, User user) async {
  bool closed = false;
  int curStage = 0;
  List<Widget> widgetList = [];
  var oriObserve = Runtime.getObserve();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('showMenuListOfUserDialog.last: $lastStage, showMenuListOfUserDialog.cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        // print('showRoleListOfUserDialog.last: $lastStage');
        yield lastStage;
      }
    }
  }

  void fetchMenuListOfConditionHandler(Map<String, dynamic> body) {
    print('showMenuListOfUserDialog.fetchMenuListOfConditionHandler');
    try {
      FetchMenuListOfConditionRsp rsp = FetchMenuListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print('body: ${rsp.body}');
        var menuList = MenuList.fromJson(rsp.body);
        widgetList = _buildWidgetList(menuList);
        curStage = 1;
        return;
      } else {
        print('showMenuListOfUserDialog.fetchMenuListOfConditionHandler failure: ${rsp.code}');
        widgetList.add(Text('获取菜单数据失败'));
        curStage = -1;
        return;
      }
    } catch (e) {
      print("showMenuListOfUserDialog.fetchMenuListOfConditionHandler failure, $e");
      widgetList.add(Text('获取菜单数据失败'));
      curStage = -1;
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showMenuListOfUserDialog.observe: major: $major, minor: $minor");
      if (major == Major.backend && minor == Minor.backend.fetchMenuListOfConditionRsp) {
        fetchMenuListOfConditionHandler(body);
      } else {
        print("showMenuListOfUserDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showMenuListOfUserDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  Runtime.setObserve(observe);

  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      fetchMenuListOfCondition(
        behavior: 2,
        userId: int.parse(user.getId()),
        roleList: RoleList([]),
      );
      return AlertDialog(
        // title: const Text('角色列表'),
        actions: [
          TextButton(
            onPressed: () {
              Runtime.setObserve(oriObserve);
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
          stream: yeildData(),
        ),
      );
    },
  ).then((value) {
    closed = true;
  });
  return Code.oK;
}

List<Widget> _buildWidgetList(MenuList menuList) {
  List<Widget> widgetList = [];
  if (menuList.getBody().isEmpty) {
    widgetList.add(Text('没有菜单数据'));
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