import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/inform.dart';
import 'package:flutter_framework/common/translator/chinese.dart';
import 'package:flutter_framework/common/translator/english.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/component/advertisement.dart';
import 'package:flutter_framework/dashboard/component/carousel.dart';
import 'package:flutter_framework/dashboard/component/deals.dart';
import 'package:flutter_framework/dashboard/component/field.dart';
import 'package:flutter_framework/dashboard/component/good.dart';
import 'package:flutter_framework/dashboard/component/menu.dart';
import 'package:flutter_framework/dashboard/component/permission.dart';
import 'package:flutter_framework/dashboard/component/role.dart';
import 'package:flutter_framework/dashboard/component/track.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/side_menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
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
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/common/business/inform/inform.dart' as inform;
import 'package:flutter_framework/common/protocol/admin/fetch_menu_list_of_condition.dart';
import 'package:flutter_framework/common/business/admin/fetch_menu_list_of_condition.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Home> {
  bool closed = false;
  int curStage = 0;
  int selected = 0;
  Duration fetchMenuDuration = const Duration(seconds: 3);
  Timer? fetchMenuTimer;
  bool isDrawerOpen = false;
  var language = Translator.getNative();
  var user = User();
  var track = Track();
  var role = Role();
  var menu = Menu();
  var permission = Permission();
  var field = Field();
  var good = Good();
  var advertisement = Advertisement();
  var deals = Deals();
  var carousel = Carousel();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('Home, last: $lastStage, cur: $curStage');
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
          print('home.navigate to $page');
          // Navigate.to(context, Screen.build(page));
          Navigate.pushReplacement(context, Screen.build(page));
        },
      );
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
        from: Screen.home,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchMenuListOfConditionRsp) {
        fetchMenuListOfConditionHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Screen.home,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.home,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void observer(PacketClient packet) {
    var caller = 'observer';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    try {
      if (major == Major.inform && minor == Inform.notification) {
        Log.debug(
          major: major,
          minor: minor,
          from: Screen.home,
          caller: caller,
          message: 'Notification',
        );
        notificationHandler(major: major, minor: minor, body: body);
      } else {
        // Log.debug(
        //   major: major,
        //   minor: minor,
        //   from: Screen.home,
        //   caller: caller,
        //   message: 'not matched',
        // );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.home,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void notificationHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'notificationHandler';
    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: '',
      );
      inform.Notification notification = inform.Notification.fromJson(body);
      if (inform.event.containsKey(notification.event)) {
        Cache.setUserId(0);
        Cache.setMemberId('');
        Cache.setSideMenuList(SideMenuList.construct(sideMenuList: []));
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.messageOfSomewhereLogin),
        ).then((value) {
          Runtime.setObserve(null);
          Runtime.setObserver(null);
          navigate(Screen.loading);
        });
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.home,
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
        from: Screen.home,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Cache.setSideMenuList(SideMenuList.fromJson(rsp.getBody()));
        curStage++;
        refresh();
        return;
      } else if (rsp.getCode() == Code.accessDenied) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.accessDeniedFailureOnFetchPermissionOfCondition),
        );
        curStage = -1;
        refresh();
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.failureWithErrorCode) + rsp.getCode().toString(),
        );
        curStage = -1;
        refresh();
        return;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.home,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void refresh() {
    // print('home.refresh');
    setState(() {});
  }

  void refreshContent() {
    user = User();
    track = Track();
    role = Role();
    menu = Menu();
    permission = Permission();
    field = Field();
    good = Good();
    advertisement = Advertisement();
    deals = Deals();
    carousel = Carousel();
  }

  void setup() {
    var caller = 'setup';
    // print('home.setup');
    Runtime.setObserve(observe);
    Runtime.setObserver(observer);
    fetchMenuListOfCondition(from: Screen.home, caller: caller, behavior: 1, userId: 0, roleList: RoleList([]));
  }

  @override
  void dispose() {
    print('home.dispose');
    if (fetchMenuTimer != null) {
      if (fetchMenuTimer!.isActive) {
        print('Home.dispose.fetchMenuTimer.cancel');
        fetchMenuTimer!.cancel();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    // print('home.initState');
    setup();
    super.initState();
  }

  Widget sideMenu() {
    if (curStage == 0) {
      return const Center(child: CircularProgressIndicator());
    } else if (curStage <= 0) {
      return Text(Translator.translate(Language.failureOnFetchMenuListOfCondition));
    }

    if (Cache.getSideMenuList().getBody().isEmpty) {
      return Text(Translator.translate(Language.noDataFailureOnFetchMenuListOfCondition));
    }

    List<Widget> widgets = [];

    Cache.getSideMenuList().getBody().forEach(
      (element) {
        widgets.add(
          ExpansionTile(
            title: Text(Translator.translate(element.getTitle())),
            children: element
                .getItemList()
                .map(
                  (title) => ListTile(
                    title: Text(Translator.translate(title)),
                    onTap: () {
                      // print('onTap: $title');
                      Cache.setContent(title);
                      curStage++;
                      if (isDrawerOpen) {
                        // print('drawer is open now');
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    return Column(
      children: widgets,
    );
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

    fetchMenuTimer = Timer(fetchMenuDuration, () {
      if (curStage == 0) {
        curStage--;
        refresh();
      }
    });

    return Scaffold(
      onDrawerChanged: (isOpened) {
        // print('onDrawerChanged: $isOpened');
        isDrawerOpen = isOpened;
      },
      onEndDrawerChanged: (isOpened) {
        // print('onEndDrawerChanged: $isOpened');
        isDrawerOpen = isOpened;
      },
      drawer: Responsive.isMedium(width) || Responsive.isSmall(width) ? drawer : null,
      appBar: AppBar(
        title: Text(Translator.translate(Language.dashboard)),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 100,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              hint: Text(
                Translator.translate(Language.fCountryCode),
              ),
              isExpanded: true,
              value: language,
              items: [
                DropdownMenuItem<String>(
                  value: Chinese.getName(),
                  child: Text(Translator.translate(Language.languageOfChinese)),
                ),
                DropdownMenuItem<String>(
                  value: English.getName(),
                  child: Text(Translator.translate(Language.languageOfEnglish)),
                ),
              ],
              onChanged: (lang) {
                Translator.setNative(lang!);
                refresh();
                refreshContent();
              },
            ),
          ),
        ],
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
              stream: stream(),
              builder: (context, snap) {
                // print('data: ${snap.data}');
                if (!Runtime.getConnectivity()) {
                  navigate(Screen.offline);
                  return const Text('');
                }
                if (snap.data != null) {
                  if (Cache.getContent() == User.content) {
                    // return const User();
                    return user;
                  } else if (Cache.getContent() == Role.content) {
                    return role;
                  } else if (Cache.getContent() == Menu.content) {
                    return menu;
                  } else if (Cache.getContent() == Permission.content) {
                    return permission;
                  } else if (Cache.getContent() == Field.content) {
                    return field;
                  } else if (Cache.getContent() == Track.content) {
                    return track;
                  } else if (Cache.getContent() == Good.content) {
                    return good;
                  } else if (Cache.getContent() == Advertisement.content) {
                    return advertisement;
                  } else if (Cache.getContent() == Deals.content) {
                    return deals;
                  } else if (Cache.getContent() == Carousel.content) {
                    return carousel;
                  } else {
                    return const Text('Unknown');
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
