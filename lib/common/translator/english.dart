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
    Language.titleOfSearch: 'Search',
    Language.reset: 'Reset',
    Language.userList: 'User List',
    Language.fPhoneNumber: 'Phone Number',
    Language.fCountryCode: 'Country Code',
    Language.fName: 'Name',
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
    Language.description: 'Description',
    Language.viewPermissionList: 'View Permission List',
    Language.viewMenuList: 'View Menu List',
    Language.viewRoleList: 'View Role List',
    Language.removeUser: 'Remove User',
    Language.update: 'Update',
    Language.remove: 'Remove',
    Language.confirmYourDeletion: 'Confirm Your Deletion?',
    Language.titleOfPermission: 'Permission',
    Language.major: 'Major',
    Language.minor: 'Minor',
    Language.fMenu: 'Parent Menu',
    Language.subMenu: 'Menu',
    Language.titleOfOperator: 'Operator',
    Language.request: 'Request',
    Language.response: 'Response',
    Language.operationTimestamp: 'Operation Timestamp',
    Language.operationLog: 'Operation Log',
    Language.table: 'Table',
    Language.fField: 'Field',
    Language.fieldList: 'Field List',
    Language.tMenu: 'Menu',
    Language.titleOfBeginDate: 'Begin Date',
    Language.titleOfEndDate: 'End Date',

    // language
    Language.languageOfChinese:'Chinese',
    Language.languageOfEnglish:'English',

    // permission
    Language.signIn: 'Sign In',
    Language.fetchMenuListOfCondition: 'Fetch Menu List',
    Language.fetchUserListOfCondition: 'Fetch User List',
    Language.fetchRoleListOfCondition: 'Fetch Role List',
    Language.fetchPermissionListOfCondition: 'Fetch Permission List',
    Language.insertUserRecord: 'Insert User',
    Language.softDeleteUserRecord: 'Remove User',
    Language.updateUserRecord: 'Update User',

    // role
    Language.titleOfRole: 'Role',
    Language.rankOfRole: 'Rank',
    Language.departmentOfRole:'Department',
    Language.administrator: 'Administrator',
    Language.rdManager: 'R&D Manager',
    Language.softwareEngineer: 'Software Engineer',
    Language.hardwareEngineer: 'Hardware Engineer',
    Language.financeManger: 'Finance Manager',
    Language.purchasingSpecialist: 'Purchasing Specialist',
    Language.accountingSpecialist: 'Accounting Specialist',
    Language.hrManger: 'HR Manger',
    Language.hrSpecialist: 'HR Specialist',
    Language.marketingManger: 'Marketing Manger',
    Language.salesSpecialist: 'Sales Specialist',
    Language.manufacturingManger: 'Manufacturing Manger',
    Language.productionSpecialist: 'Production Specialist',
    Language.descriptionOfAdministrator: 'The top role of this organization',
    Language.descriptionOfRDManager: 'The manager of Research and Development department',
    Language.descriptionOfSoftwareEngineer: 'A Software Engineer of Research and Development department',
    Language.descriptionOfHardwareEngineer: 'A Hardware Engineer of Research and Development department',
    Language.descriptionOfFinanceManger: 'The manager of Finance Department',
    Language.descriptionOfPurchasingSpecialist: 'A Purchasing Specialist of Finance Department',
    Language.descriptionOfAccountingSpecialist: 'A Accounting Specialist of Finance Department',
    Language.descriptionOfHRManger: 'The manager of Human Resources Department',
    Language.descriptionOfHRSpecialist: 'A Human Resources Specialist of Human Resources Department',
    Language.descriptionOfMarketingManger: 'The manager of Marketing Department',
    Language.descriptionOfSalesSpecialist: 'A Sales Specialist of Marketing Department',
    Language.descriptionOfManufacturingManger: 'The manager of Manufacturing Department',
    Language.descriptionOfProductionSpecialist: 'A Production Specialist of Manufacturing Department',

    // dialog
    Language.titleOfErrorNotifyDialog: 'Error',
    Language.passwordInTwoInputControlDoNotMatch: 'Password not matched',
    Language.titleOfNotification : 'Notification',
    Language.messageOfSomewhereLogin : 'Your account login somewhere.',
    Language.endDateIsBeforeBeginDate: 'The End DateTime is Before Begin DateTime',

    // inform.notification
    Language.eventForceOffline: 'Force Offline',
    Language.messageForceOffline : 'Your account has been logon somewhere! Your have to logout immediately.',
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
