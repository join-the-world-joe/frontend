import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/dashboard/model/track_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import '../model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';

class Cache {
  static String _token = '';
  static String _secret = '';
  static String _role = '';
  static late int _userId;
  static late MenuList _menuList;
  static String _content = '';
  static List<User> userList = [];
  static late RoleList _roleList;
  static TrackList trackList = TrackList([], 0);
  static late PermissionList _permissionList;

  static setPermissionList(PermissionList any) {
    _permissionList = any;
  }

  static PermissionList getPermissionList() {
    return _permissionList;
  }

  static setRoleList(RoleList any) {
    _roleList = any;
  }

  static RoleList getRoleList() {
    return _roleList;
  }

  static setTrackList(TrackList any) {
    trackList = any;
  }

  static TrackList getTrackList() {
    return trackList;
  }

  static setUserList(List<User> any) {
    userList = any;
  }

  static List<User> getUserList() {
    return userList;
  }

  static setSecret(String any) {
    _secret = any;
  }

  static String getSecret() {
    return _secret;
  }

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
