import '../model/menu_list.dart';

class Cache {
  static late String _token;
  static String _role = '';
  static late int _userId;
  static late MenuList _menuList;
  static String _content = '';

  static setToken(String any) {
    _token = any;
  }

  static String getToken() {
    return _token;
  }

  static setRole(String any) {
    _role = any;
  }

  static String getRole() {
    return _role;
  }

  static setUserId(int any) {
    _userId = any;
  }

  static int getUserId() {
    return _userId;
  }

  static void setMenuList(MenuList any) {
    _menuList = any;
  }

  static MenuList getMenuList() {
    return _menuList;
  }

  static setContent(String any) {
    _content = any;
  }

  static getContent() {
    return _content;
  }
}
