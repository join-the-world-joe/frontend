import 'user.dart';

class UserList {
  List<User> _body = [];

  int getLength() {
    return _body.length;
  }

  UserList.construct({required List<User> userList}) {
    _body = userList;
  }

  List<User> getBody() {
    return _body;
  }

  UserList.fromJson(Map<String, dynamic> json) {
    List<User> userList = [];
    if (json.containsKey('user_list')) {
      List<dynamic> any = json['user_list'];
      for (var element in any) {
        userList.add(
          User.construct(
            id: element['id'],
            status: element['status'],
            name: element['name'],
            account: element['account'],
            email: element['email'],
            department: element['department'],
            countryCode: element['country_code'],
            phoneNumber: element['phone_number'],
            createdAt: element['created_at'],
          ),
        );
      }
    }
    _body = userList;
  }
}
