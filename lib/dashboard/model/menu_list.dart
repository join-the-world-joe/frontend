import 'menu.dart';

class MenuList {
  List<Menu> _body;

  MenuList(this._body);

  List<Menu> getBody() {
    return _body;
  }

  factory MenuList.fromJson(Map<String, dynamic> json) {
    List<Menu> ml = [];
    try {
      json.forEach(
        (key, value) {
          print("key: $key");
          print("value: $value");
          List<String> itemList = List<String>.from(value['Item'] as List);
          List<String> descList =
              List<String>.from(value['Description'] as List);
          ml.add(Menu(key, itemList, descList));
        },
      );
    } catch (e) {
      print('e: $e');
    }

    return MenuList(ml);
  }
}
