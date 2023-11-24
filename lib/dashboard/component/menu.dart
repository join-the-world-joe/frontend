import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/side_menu_list.dart';
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

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  static String content = 'Menu';

  @override
  State createState() => _State();
}

class _State extends State<Menu> {
  bool closed = false;
  int curStage = 1;
  TextEditingController menuController = TextEditingController();
  TextEditingController parentController = TextEditingController();

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
          print('Menu.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    print('Menu.setup');
    Cache.setMenuList(MenuList([], 0));
    Runtime.setObserve(observe);
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("Menu.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.fetchMenuListOfConditionRsp) {
        fetchMenuListOfConditionHandler(body);
        curStage++;
      } else {
        print("Menu.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Menu.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void fetchMenuListOfConditionHandler(Map<String, dynamic> body) {
    print('Menu.fetchMenuListOfConditionHandler');
    try {
      FetchMenuListOfConditionRsp rsp = FetchMenuListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print('body: ${rsp.body}');
        var menuList = MenuList.fromJson(rsp.body);
        Cache.setMenuList(menuList);
        curStage++;
        return;
      } else {
        print('Menu.fetchMenuListOfConditionHandler failure: ${rsp.code}');
        curStage = -1;
        return;
      }
    } catch (e) {
      print("Menu.fetchMenuListOfConditionHandler failure, $e");
      curStage = -1;
      return;
    }
  }

  @override
  void dispose() {
    print('Menu.dispose');
    super.dispose();
  }

  @override
  void initState() {
    print('Menu.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        controller: menuController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.subMenu),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: parentController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.titleOfParentMenu),
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
                            minor: int.parse(Minor.admin.fetchMenuListOfConditionReq),
                          )) {
                            return;
                          }
                          fetchMenuListOfCondition(
                            behavior: 2,
                            userId: Cache.getUserId(),
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
                          Cache.setMenuList(MenuList([], 0));
                          menuController.text = '';
                          parentController.text = '';
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
                PaginatedDataTable(
                  source: Source(context),
                  header: Text(Translator.translate(Language.menuList)),
                  columns: [
                    DataColumn(label: Text(Translator.translate(Language.subMenu))),
                    DataColumn(label: Text(Translator.translate(Language.titleOfParentMenu))),
                    DataColumn(label: Text(Translator.translate(Language.description))),
                  ],
                  columnSpacing: 60,
                  horizontalMargin: 10,
                  rowsPerPage: 5,
                  showCheckboxColumn: false,
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
  MenuList menuList = Cache.getMenuList();

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => () {
        return menuList.getLength();
      }();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(Translator.translate(menuList.getBody()[index].getName()))),
        DataCell(Text(Translator.translate(menuList.getBody()[index].getParent()))),
        DataCell(Text(Translator.translate(menuList.getBody()[index].getDescription()))),
      ],
    );
  }
}
