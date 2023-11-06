import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/backend/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/dashboard/component/field.dart';
import 'package:flutter_framework/dashboard/component/menu.dart';
import 'package:flutter_framework/dashboard/component/permission.dart';
import 'package:flutter_framework/dashboard/component/role.dart';
import 'package:flutter_framework/dashboard/component/track.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/menu_list.dart';
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
import 'package:flutter_framework/framework/packet_client.dart';

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

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("Home.observe: major: $major, minor: $minor");
    try {
      if (major == Major.backend &&
          minor == Minor.backend.fetchMenuListOfConditionRsp) {
        fetchMenuListOfConditionHandler(body);
      } else {
        print("Home.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Home.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void fetchMenuListOfConditionHandler(Map<String, dynamic> body) {
    print('Home.fetchMenuListOfConditionHandler');
    try {
      FetchMenuListOfConditionRsp rsp =
          FetchMenuListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        Cache.setMenuList(MenuList.fromJson(rsp.body));
        curStage = 1;
        refresh();
        return;
      } else {
        print('Home.fetchMenuListOfConditionHandler failure: ${rsp.code}');
        return;
      }
    } catch (e) {
      print("Home.fetchMenuListOfConditionHandler failure, $e");
      return;
    }
  }

  void refresh() {
    print('home.refresh');
    setState(() {});
  }

  void navigate(String page) {
    print('home.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    print('home.setup');
    Runtime.setObserve(observe);
    fetchMenuListOfCondition(conditionOfRoleList: []);
  }

  void progress() async {
    print('home.progress');
    return;
  }

  void debug() async {
    print('home.debug');
    var body =
        '{"Admission":["User","Role","Permission","Menu","Track", "Field"],"Menu1":["item1","item2","item3","item4","item5"]}';
    Cache.setMenuList(MenuList.fromJson(jsonDecode(body)));

    await Future.delayed(const Duration(seconds: 1));
    curStage = 1;
    refresh();
  }

  @override
  void dispose() {
    print('home.dispose');
    super.dispose();
  }

  @override
  void initState() {
    print('home.initState');
    setup();
    progress();
    // debug();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isLarge(width))
            Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  width: 150,
                  child: SingleChildScrollView(
                    child: sideMenu(),
                  ),
                );
              },
            ),
          Spacing.addHorizontalSpace(20),
          Expanded(
            child: StreamBuilder(
              builder: (context, snap) {
                print('data: ${snap.data}');
                if (snap.data != null) {
                  if (Cache.getContent() == User.content) {
                    return const User();
                  } else if (Cache.getContent() == Role.content) {
                    return const Role();
                  } else if (Cache.getContent() == Menu.content) {
                    return const Menu();
                  } else if (Cache.getContent() == Permission.content) {
                    return const Permission();
                  } else if (Cache.getContent() == Field.content) {
                    return const Field();
                  } else if (Cache.getContent() == Track.content) {
                    return const Track();
                  } else {
                    return const Text('Unknown');
                  }
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
