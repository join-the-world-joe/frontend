import 'permission.dart';

class PermissionList {
  List<Permission> _body = [];
  int _length = 0;

  PermissionList(List<Permission> any) {
    _body = any;
    _length = any.length;
  }

  List<Permission> getBody() {
    return _body;
  }

  int getLength() {
    return _length;
  }

  factory PermissionList.fromJson(Map<String, dynamic> json) {
    List<Permission> pl = [];
    try {
      // List<Permission> permissionList = [];
      if (json['permission_list'] != null) {
        List<dynamic> any = json['permission_list'];
        any.forEach(
          (element) {
            pl.add(Permission.fromJson(element));
          },
        );
      }
      return PermissionList(pl);
    } catch (e) {
      print('PermissionList failure, e: $e');
    }

    return PermissionList(pl);
  }
}
