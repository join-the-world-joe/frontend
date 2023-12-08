import 'permission.dart';

class PermissionList {
  List<Permission> _body = [];

  PermissionList(List<Permission> any) {
    _body = any;
  }

  List<Permission> getBody() {
    return _body;
  }

  int getLength() {
    return _body.length;
  }

  PermissionList.fromJson(Map<String, dynamic> json) {
    List<Permission> pl = [];

    if (json.containsKey('permission_list')) {
      List<dynamic> any = json['permission_list'];
      for (var element in any) {
        pl.add(
          Permission.construct(
            name: element['name'],
            major: element['major'],
            minor: element['minor'],
            description: element['description'],
          ),
        );
      }
    }
    _body = pl;
  }
}
