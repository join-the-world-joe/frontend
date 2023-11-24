import 'side_menu.dart';

class SideMenuList {
  int _length;
  List<SideMenu> _body;

  SideMenuList(this._body, this._length);

  List<SideMenu> getBody() {
    return _body;
  }

  int getLength() {
    return _length;
  }

  factory SideMenuList.fromJson(Map<String, dynamic> json) {
    List<SideMenu> ml = [];
    try {
      json.forEach(
        (key, value) {
          // print("key: $key");
          // print("value: $value");
          List<String> itemList = List<String>.from(value['item_list'] as List);
          List<String> descList = List<String>.from(value['description_list'] as List);
          ml.add(SideMenu(key, itemList, descList));
        },
      );
    } catch (e) {
      print('e: $e');
    }

    return SideMenuList(ml, ml.length);
  }
}
