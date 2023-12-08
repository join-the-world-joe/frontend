import 'role.dart';

class RoleList {
  List<Role> _body = [];

  int getLength() {
    return _body.length;
  }

  RoleList(List<Role> roleList) {
    _body = roleList;
  }

  List<Role> getBody() {
    return _body;
  }

  List<String> getNameList() {
    List<String> nameList = [];
    for (var element in _body) {
      nameList.add(element.getName());
    }
    return nameList;
  }

  RoleList.fromJson(Map<String, dynamic> json) {
    List<Role> roleList = [];
    if (json.containsKey('role_list')) {
      List<dynamic> any = json['role_list'];
      for (var element in any) {
        roleList.add(
          Role.construct(
            rank: element['rank'],
            name: element['name'],
            department: element['department'],
            description: element['description'],
          ),
        );
      }
    }

    _body = roleList;
  }
}
