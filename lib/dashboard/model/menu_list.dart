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
    List<String> itemList = [];
    List<String> descList = [];

    json.forEach(
      (key, value) {
        // print("key: $key");
        // print("value: $value");
        itemList = [];
        descList = [];
        if (json.containsKey('item_list')) {
          itemList = List<String>.from(value['item_list'] as List);
        }
        if (json.containsKey('description_list')) {
          descList = List<String>.from(value['description_list'] as List);
        }
        if (itemList.isNotEmpty && descList.isNotEmpty) {
          ml.add(
            Menu.construct(
              name: key,
              parent: Language.valueOfNull,
              description: key,
            ),
          );
          for (var i = 0; i < itemList.length; i++) {
            ml.add(
              Menu.construct(
                name: itemList[i],
                parent: key,
                description: descList[i],
              ),
            );
          }
        }
      },
    );

    return MenuList(ml);
  }
}
