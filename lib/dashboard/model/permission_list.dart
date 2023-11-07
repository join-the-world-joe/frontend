import 'permission.dart';

class PermissionList {
  List<Permission> _body;

  PermissionList(this._body);

  List<Permission> getBody() {
    return _body;
  }

  factory PermissionList.fromJson(Map<String, dynamic> json) {
    List<Permission> pl = [];
    try {
      json.forEach(
        (key, value) {
          print("key: $key");
          print("value: $value");
          var name = key;
          var major = value['major'];
          var minor = value['minor'];
          var description = value['description'];
          pl.add(Permission(name, major, minor, description));
        },
      );
    } catch (e) {
      print('e: $e');
    }

    return PermissionList(pl);
  }
}
