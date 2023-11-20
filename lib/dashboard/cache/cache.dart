import 'package:flutter_framework/dashboard/model/permission_list.dart';
import 'package:flutter_framework/dashboard/model/track_list.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import '../model/menu_list.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';

class Cache {
  static String _memberId = '';
  static String _secret = '';
  static String _role = '';
  static int _userId = 0;
  static MenuList _menuList = MenuList([], 0);
  static String _content = '';
  static List<User> userList = [];
  static RoleList _roleList = RoleList([]);
  static TrackList trackList = TrackList([]);
  static PermissionList _permissionList = PermissionList([]);

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

  static setMemberId(String any) {
    _memberId = any;
  }

  static String getMemberId() {
    return _memberId;
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
