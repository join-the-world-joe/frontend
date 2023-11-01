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
          // print("key: $key");
          // print("value: $value");
          List<String> item = [];
          item = List<String>.from(value as List);
          ml.add(Menu(key, item));
        },
      );
    } catch (e) {
      print('e: $e');
    }

    return MenuList(ml);
  }
}
