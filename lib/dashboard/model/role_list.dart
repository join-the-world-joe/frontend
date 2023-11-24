import 'role.dart';

class RoleList {
  List<Role> _body = [];
  int _length = 0;

  int getLength() {
    return _length;
  }

  RoleList(List<Role> roleList) {
    _body = roleList;
    _length = _body.length;
  }

  List<Role> getBody() {
    return _body;
  }

  List<String> getNameList() {
    List<String> nameList = [];
    _body.forEach((element) {
      nameList.add(element.getName());
    });
    return nameList;
  }

  factory RoleList.fromJson(Map<String, dynamic> json) {
    List<Role> rl = [];
    try {
      List<Role> roleList = [];
      if (json['role_list'] != null) {
        List<dynamic> any = json['role_list'];
        any.forEach((element) {
          roleList.add(Role.fromJson(element));
        });
      }
      return RoleList(roleList);
    } catch (e) {
      print('RoleList failure, e: $e');
    }

    return RoleList(rl);
  }
}