import 'user.dart';

class UserList {
  List<User> _body = [];
  int _length = 0;

  int getLength() {
    return _length;
  }

  UserList(List<User> any) {
    _body = any;
    _length = any.length;
  }

  List<User> getBody() {
    return _body;
  }

  factory UserList.fromJson(Map<String, dynamic> json) {
    List<User> ul = [];
    try {
      List<User> userList = [];
      if (json['user_list'] != null) {
        List<dynamic> any = json['user_list'];
        any.forEach((element) {
          userList.add(User.fromJson(element));
        });
      }
      return UserList(userList);
    } catch (e) {
      print('UserList failure, e: $e');
    }

    return UserList(ul);
  }
}
