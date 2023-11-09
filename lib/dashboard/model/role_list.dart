import 'role.dart';

class RoleList {
  List<Role> _body;

  RoleList(this._body);

  List<Role> getBody() {
    return _body;
  }

  List<String> getNameList() {
    List<String> nameList = [];
    _body.forEach((element) {
      nameList.add(element.getName());
    });
    return [];
  }

  factory RoleList.fromJson(Map<String, dynamic> json) {
    List<Role> rl = [];
    try {
      List<String> nameList = List<String>.from(json['name_list']);
      List<String> descList = List<String>.from(json['description_list']);
      List<String> levelList = List<String>.from(json['level_list']);
      for (var i = 0; i < nameList.length; i++) {
        rl.add(Role(nameList[i], levelList[i], descList[i]));
      }
    } catch (e) {
      print('e: $e');
    }

    return RoleList(rl);
  }
}
