import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/backend/fetch_menu_list_of_role.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import '../responsive.dart';
import '../config/config.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/framework/routing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../setup.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Home> {
  int curStage = 0;
  final String title = Config.title;
  int _selectedIndex = 0;
  int selected = 0;
  Timer? fetchMenuListOfRoleTimer;
  bool isDrawerOpen = false;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void fetchMenuListOfRoleHandler(Map<String, dynamic> body) {
    try {
      FetchMenuListOfRoleRsp rsp = FetchMenuListOfRoleRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        Cache.setMenuList(MenuList.fromJson(rsp.body));
        curStage = 1;
        refresh();
        return;
      } else {
        print('Home.fetchMenuListOfRoleHandler failure: ${rsp.code}');
        return;
      }
    } catch (e) {
      print("Home.fetchMenuListOfRoleHandler failure, $e");
      return;
    }
  }

  void refresh() {
    setState(() {});
  }

  void navigate(String page) {
    print('navigate to $page');
    Runtime.hook.unRegister(
      Routing.key(
          major: Major.backend, minor: Minor.backend.fetchMenuListOfRoleRsp),
    );
    // Runtime.hook.clear();
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    Runtime.hook.register(
      Routing.key(
          major: Major.backend, minor: Minor.backend.fetchMenuListOfRoleRsp),
      fetchMenuListOfRoleHandler,
    );
  }

  void progress() async {
    // fetch menu list of role
    // fetchMenuListOfRole(query: Cache.getRole());
    return;
  }

  void debug() async {
    var body =
        '{"Admission":["User","Role","Permission","Menu","Track"],"Menu1":["item1","item2","item3","item4","item5"]}';
    Cache.setMenuList(MenuList.fromJson(jsonDecode(body)));

    await Future.delayed(const Duration(seconds: 1));
    curStage = 1;
    refresh();
  }

  Stream<String>? yeildData() async* {
    var lastContent = '';
    while (true) {
      await Future.delayed(Config.contentAreaRefreshInterval);
      if (lastContent != Cache.getContent()) {
        lastContent = Cache.getContent();
        // print('lastContent: $lastContent');
        yield lastContent;
      }
    }
  }

  @override
  void dispose() {
    print('home.dispose');
    super.dispose();
  }

  @override
  void initState() {
    setup();
    progress();
    debug();
    super.initState();
  }

  Widget sideMenu() {
    if (curStage == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (curStage <= 0) {
      return const Text('获取菜单数据失败');
    }

    if (Cache.getMenuList().getBody().isEmpty) {
      return const Text('没有菜单数据');
    }

    List<Widget> widgets = [];

    Cache.getMenuList().getBody().forEach(
      (element) {
        widgets.add(
          ExpansionTile(
            title: Text(element.getTitle()),
            children: element
                .getItemList()
                .map((title) => ListTile(
                      title: Text(title),
                      onTap: () {
                        // print('onTap: $title');
                        Cache.setContent(title);
                        if (isDrawerOpen) {
                          // print('drawer is open now');
                          Navigator.of(context).pop();
                        }
                      },
                    ))
                .toList(),
          ),
        );
      },
    );

    return Column(
      children: widgets,
    );

    return Text('sideMenu default');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          const Divider(),
          sideMenu(),
        ],
      ),
    );

    return Scaffold(
      onDrawerChanged: (isOpened) {
        // print('onDrawerChanged: $isOpened');
        isDrawerOpen = isOpened;
      },
      onEndDrawerChanged: (isOpened) {
        // print('onEndDrawerChanged: $isOpened');
        isDrawerOpen = isOpened;
      },
      drawer: Responsive.isMedium(width) || Responsive.isSmall(width)
          ? drawer
          : null,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Row(
        children: [
          if (Responsive.isLarge(width))
            Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: 150,
                  child: sideMenu(),
                );
              },
            ),
          Expanded(
            child: StreamBuilder(
              builder: (context, snap) {
                print('data: ${snap.data}');
                if (snap.data != null) {
                  return Container(
                    color: Colors.lightBlue,
                    child: Text(snap.data!),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
              stream: yeildData(),
            ),
          ),
        ],
      ),
    );
  }
}
