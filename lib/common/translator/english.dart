import 'package:flutter_framework/common/translator/language.dart';

class English {
  static const String _name = 'English';
  static Map<String, String> model = {
    Language.admission: 'Admission',
    Language.user: 'User',
    Language.role: 'Role',
    Language.field: 'Field',
    Language.menu: 'Menu',
    Language.permission: 'Permission',
    Language.track: 'Track',
    Language.search: 'Search',
    Language.reset: 'Reset',
    Language.userList: 'User List',
    Language.fPhoneNumber: 'Phone Number',
    Language.fCountryCode: 'Country Code',
    Language.fName: 'Name',
    Language.fRole: 'Role',
    Language.fStatus: 'Status',
    Language.fCreatedAt: 'CreatedAt',
    Language.roleList: 'Role List',
    Language.permissionList: 'Permission List',
    Language.menuList: 'Menu List',
    Language.operation: 'Operation',
    Language.newUser: 'New User',
    Language.cancel: 'Cancel',
    Language.confirm: "Confirm",
    Language.enable: 'Enable',
    Language.disable: 'Disable',
    Language.china: 'China',
    Language.philipine: 'Philipine',
    Language.password: 'Password',
    Language.confirmPassword: 'Confirm Password',
    Language.modifyUser: 'Modify User',
    Language.dashboard: 'General Admin Panel',
    Language.ok: 'OK',
    Language.level: 'Level',
    Language.description: 'Description',
    Language.viewPermissionList: 'View Permission List',
    Language.viewMenuList: 'View Menu List',
    Language.viewRoleList: 'View Role List',
    Language.removeUser: 'Remove User',
    Language.update: 'Update',
    Language.remove: 'Remove',
    Language.confirmYourDeletion: 'Confirm Your Deletion?',
    Language.fPermission: 'Permission',
    Language.major: 'Major',
    Language.minor: 'Minor',
    Language.fMenu: 'Parent Menu',
    Language.subMenu: 'Menu',
    Language.operator: 'Operator',
    Language.request: 'Request',
    Language.response: 'Response',
    Language.operationTimestamp: 'Operation Timestamp',
    Language.operationLog: 'Operation Log',
    Language.table: 'Table',
    Language.fField: 'Field',
    Language.fieldList: 'Field List',
    Language.tMenu:'Menu',

    // permission
    Language.fetchMenuListOfCondition: 'Fetch Menu List',
    Language.fetchUserListOfCondition: 'Fetch User List',
    Language.fetchRoleListOfCondition: 'Fetch Role List',
    Language.fetchPermissionListOfCondition: 'Fetch Permission List',
    Language.insertUserRecord : 'Insert User',
  };

  static String getName() {
    return _name;
  }

  static String translate(String input) {
    if (model.containsKey(input)) {
      return model[input]!;
    } else {
      return 'Unknown input: $input';
    }
  }
}
