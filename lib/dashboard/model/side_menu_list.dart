import 'side_menu.dart';

class SideMenuList {
  List<SideMenu> _body = [];

  // SideMenuList(this._body, );

  SideMenuList.construct({required List<SideMenu> sideMenuList}) {
    _body = sideMenuList;
  }

  List<SideMenu> getBody() {
    return _body;
  }

  int getLength() {
    return _body.length;
  }

  SideMenuList.fromJson(Map<String, dynamic> json) {
    List<SideMenu> ml = [];

    json.forEach(
      (key, value) {
        // print("key: $key");
        // print("value: $value");
        List<String> itemList = List<String>.from(value['item_list'] as List);
        List<String> descList = List<String>.from(value['description_list'] as List);
        ml.add(SideMenu.construct(title: key, itemList: itemList, descList: descList));
      },
    );

    _body = ml;
  }
}
