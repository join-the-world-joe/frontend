import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/translator/chinese.dart';
import 'package:flutter_framework/common/translator/english.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/side_menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
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
import 'package:flutter_framework/common/protocol/admin/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/common/business/admin/fetch_menu_list_of_condition.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  static String content = 'Menu';

  @override
  State createState() => _State();
}

class _State extends State<Menu> {
  bool closed = false;
  int curStage = 1;
  String menuFilter = '';
  String parentFilter = '';
  TextEditingController menuController = TextEditingController();
  TextEditingController parentController = TextEditingController();

  var chinese = <String, String>{
    Chinese.model[Language.menuOfUser]!: Language.menuOfUser,
    Chinese.model[Language.menuOfRole]!: Language.menuOfRole,
    Chinese.model[Language.menuOfMenu]!: Language.menuOfMenu,
    Chinese.model[Language.menuOfTrack]!: Language.menuOfTrack,
    Chinese.model[Language.menuOfField]!: Language.menuOfField,
    Chinese.model[Language.menuOfAdmission]!: Language.menuOfAdmission,
    Chinese.model[Language.menuOfPermission]!: Language.menuOfPermission,
  };
  var english = <String, String>{
    English.model[Language.menuOfUser]!: Language.menuOfUser,
    English.model[Language.menuOfRole]!: Language.menuOfRole,
    English.model[Language.menuOfMenu]!: Language.menuOfMenu,
    English.model[Language.menuOfTrack]!: Language.menuOfTrack,
    English.model[Language.menuOfField]!: Language.menuOfField,
    English.model[Language.menuOfAdmission]!: Language.menuOfAdmission,
    English.model[Language.menuOfPermission]!: Language.menuOfPermission,
  };

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
    // print('Menu.setup');
    Cache.setMenuList(MenuList([]));
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
        from: Menu.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchMenuListOfConditionRsp) {
        fetchMenuListOfConditionHandler(major: major, minor: minor, body: body);
        curStage++;
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Menu.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Menu.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void fetchMenuListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchMenuListOfConditionHandler';
    try {
      FetchMenuListOfConditionRsp rsp = FetchMenuListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Menu.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        // print('body: ${rsp.getBody()}');
        var menuList = MenuList.fromJson(rsp.getBody());
        var output = menuList;
        if (menuFilter.isNotEmpty || parentFilter.isNotEmpty) {
          output = MenuList([]);
          if (menuFilter.isNotEmpty) {
            // print('menuFilter: $menuFilter');
            chinese.forEach(
              (key, value) {
                if (key.contains(menuFilter)) {
                  // print('contains.key: $key, value: $value');
                  menuList.getBody().forEach(
                    (element) {
                      if (element.getName().compareTo(value) == 0) {
                        if (!output.getBody().contains(element)) {
                          // print('chinese menu add: ${element.getName()}');
                          output.getBody().add(element);
                        }
                      }
                    },
                  );
                }
              },
            );
            english.forEach(
              (key, value) {
                if (key.contains(menuFilter)) {
                  // print('contains.key: $key, value: $value');
                  menuList.getBody().forEach(
                    (element) {
                      if (element.getName().compareTo(value) == 0) {
                        if (!output.getBody().contains(element)) {
                          // print('english menu add: ${element.getName()}');
                          output.getBody().add(element);
                        }
                      }
                    },
                  );
                }
              },
            );
          }
          if (parentFilter.isNotEmpty) {
            // print('parentFilter: $menuFilter');
            chinese.forEach(
              (key, value) {
                if (value.contains(parentFilter)) {
                  menuList.getBody().forEach(
                    (element) {
                      if (element.getParent().compareTo(value) == 0) {
                        if (!output.getBody().contains(element)) {
                          output.getBody().add(element);
                        }
                      }
                    },
                  );
                }
              },
            );
            english.forEach(
              (key, value) {
                if (value.contains(parentFilter)) {
                  menuList.getBody().forEach(
                    (element) {
                      if (element.getParent().compareTo(value) == 0) {
                        if (!output.getBody().contains(element)) {
                          output.getBody().add(element);
                        }
                      }
                    },
                  );
                }
              },
            );
          }
        }
        Cache.setMenuList(output);
        curStage++;
        return;
      } else {
        print('Menu.fetchMenuListOfConditionHandler failure: ${rsp.getCode()}');
        curStage = -1;
        return;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Menu.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      curStage = -1;
      return;
    }
  }

  @override
  void dispose() {
    // print('Menu.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('Menu.initState');
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
                            minor: int.parse(Admin.fetchMenuListOfConditionReq),
                          )) {
                            return;
                          }
                          Cache.setMenuList(MenuList([]));
                          if (menuController.text.isNotEmpty) {
                            menuFilter = menuController.text;
                          }
                          if (parentController.text.isNotEmpty) {
                            parentFilter = parentController.text;
                          }
                          fetchMenuListOfCondition(
                            from: Menu.content,
                            caller: '$caller.fetchMenuListOfCondition',
                            behavior: 2,
                            userId: Cache.getUserId(),
                            roleList: RoleList([]),
                          );
                          curStage++;
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
                          Cache.setMenuList(MenuList([]));
                          menuController.text = '';
                          parentController.text = '';
                          menuFilter = '';
                          parentFilter = '';
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
