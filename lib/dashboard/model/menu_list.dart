import 'menu.dart';

class MenuList {
  int _length;
  List<Menu> _body;

  MenuList(this._body, this._length);

  List<Menu> getBody() {
    return _body;
  }

  int getLength() {
    return _length;
  }

  factory MenuList.fromJson(Map<String, dynamic> json) {
    List<Menu> ml = [];
    try {
      json.forEach(
        (key, value) {
          // print("key: $key");
          // print("value: $value");
          List<String> itemList = List<String>.from(value['item_list'] as List);
          List<String> descList = List<String>.from(value['description_list'] as List);
          ml.add(Menu(key, itemList, descList));
        },
      );
    } catch (e) {
      print('e: $e');
    }

    return MenuList(ml, ml.length);
  }
}
