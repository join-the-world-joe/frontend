import 'package:flutter_framework/common/translator/language.dart';

import 'menu.dart';

class MenuList {
  List<Menu> _body;

  MenuList(this._body);

  List<Menu> getBody() {
    return _body;
  }

  int getLength() {
    return _body.length;
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
          ml.add(Menu(key, Language.valueOfNull, key));
          for (var i = 0; i < itemList.length; i++) {
            ml.add(Menu(itemList[i], key, descList[i]));
          }
        },
      );
    } catch (e) {
      print('e: $e');
    }

    return MenuList(ml);
  }
}
