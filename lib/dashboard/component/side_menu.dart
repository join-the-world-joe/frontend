// import 'package:flutter/material.dart';
//
// class SideMenu extends StatefulWidget {
//   SideMenu({Key? key}) : super(key: key);
//
//   @override
//   State createState() => _State();
// }
//
// class _State extends State<SideMenu> {
//   int curStage = 0; // -1, 加载页面数据失败; 1, 加载成功;
//   int selected = 0; //attention
//   bool fMenuList = false;
//
//   void setup() {
//     // 此处放置初始化前的逻辑
//   }
//
//   void progress() async {
//     return;
//   }
//
//   @override
//   void initState() {
//     setup();
//     progress();
//     super.initState();
//   }
//
//   void refresh() {
//     setState(() {});
//   }
//
//   List<Widget> ParseMenuList() {
//     Map<int, List<Menu>> m = {};
//     List<Widget> widgets = [];
//
//     var list = Cache.GetMenuList();
//     if (list.isEmpty) {
//       return widgets;
//     }
//
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].GetParentId() == 0 && Menu.TitleSet.containsKey(list[i].GetTitle())) {
//         m[list[i].GetId()] = [];
//         m[list[i].GetId()]?.add(list[i]);
//       }
//     }
//
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].GetParentId() != 0 && Menu.TitleSet.containsKey(list[i].GetTitle())) {
//         if (m.containsKey(list[i].GetParentId())) {
//           m[list[i].GetParentId()]?.add(list[i]);
//         }
//       }
//     }
//
//     m.forEach(
//           (k, v) {
//         var main = v[0];
//         v.removeAt(0);
//         widgets.add(
//           ExpansionTile(
//             initiallyExpanded: selected == k,
//             onExpansionChanged: ((b) {
//               if (b) {
//                 selected = k;
//               } else {
//                 selected = -1;
//               }
//               refresh();
//             }),
//             title: Text(Menu.TitleSet[main.GetTitle()].toString() ?? 'N/A'),
//             children: v
//                 .map((e) => ListTile(
//                 title: Text(Menu.TitleSet[e.GetTitle()].toString() ?? 'N/A'),
//                 onTap: () {
//                   Menu.Handle(e.GetTitle());
//                 }))
//                 .toList(),
//           ),
//         );
//       },
//     );
//
//     return widgets;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Builder(
//         // key: Key(selected.toString()),
//         builder: (context) {
//           return ListView(
//             // key: Key(selected.toString()), // 打开, 可控制菜单自动弹收
//             children: [
//               Spacing.AddVerticalSpace(50),
//               Image.asset("lib/common/admin-panel/asset/image/logo.png"),
//               const Divider(),
//               Builder(builder: (BuildContext context) {
//                 if (curStage == 0) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (Cache.GetMenuList().isEmpty) return const Text('获取菜单失败');
//                 return Column(
//                   children: ParseMenuList(),
//                 );
//               }),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
