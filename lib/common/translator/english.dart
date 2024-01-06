import 'package:flutter_framework/common/translator/language.dart';

class English {
  static const String _name = 'English';
  static Map<String, String> model = {
    Language.titleOfSearch: 'Search',
    Language.reset: 'Reset',
    Language.fPhoneNumber: 'Phone Number',
    Language.fCountryCode: 'Country Code',
    Language.fName: 'Name',
    Language.fStatus: 'Status',
    Language.fCreatedAt: 'CreatedAt',
    Language.roleList: 'Role List',
    Language.permissionList: 'Permission List',
    Language.menuList: 'Menu List',
    Language.operation: 'Operation',
    Language.cancel: 'Cancel',
    Language.next: 'Next',
    Language.back: 'Back',
    Language.confirm: "Confirm",
    Language.enable: 'Enable',
    Language.disable: 'Disable',
    Language.china: 'China',
    Language.philipine: 'Philipine',
    Language.password: 'Password',
    Language.confirmPassword: 'Confirm Password',
    Language.dashboard: 'General Admin Panel',
    Language.ok: 'OK',
    Language.viewPermissionList: 'View Permission List',
    Language.viewMenuList: 'View Menu List',
    Language.viewRoleList: 'View Role List',
    Language.update: 'Update',
    Language.remove: 'Remove',
    Language.removing: 'Remove Record',
    Language.confirmYourDeletion: 'Confirm Your Deletion?',
    Language.titleOfPermission: 'Permission',
    Language.major: 'Major',
    Language.minor: 'Minor',
    Language.subMenu: 'Menu',
    Language.titleOfOperator: 'Operator',
    Language.request: 'Request',
    Language.response: 'Response',
    Language.operationTimestamp: 'Operation Timestamp',
    Language.operationLog: 'Operation Log',
    Language.fieldList: 'Field List',
    Language.tMenu: 'Menu',
    Language.titleOfBeginDate: 'Begin Date',
    Language.titleOfEndDate: 'End Date',

    // user
    Language.newUser: 'New User',
    Language.userList: 'User List',
    Language.removeUser: 'Remove User',
    Language.modifyUser: 'Modify User',
    Language.nameOfUserNotProvided: "User name not provided",
    Language.passwordOfUserNotProvided: "Password is empty",
    Language.twoPasswordNotEqual: "Two password not equal",
    Language.phoneNumberNotProvided: "Phone number not provided",

    // language
    Language.languageOfChinese: 'Chinese',
    Language.languageOfEnglish: 'English',

    // common
    Language.description: 'Description',
    Language.valueOfNull: '',
    Language.loading: "Loading",
    Language.clickToView: "Click to view",
    Language.titleOfRefreshOperation: 'Refresh',
    Language.accessDenied: 'Access Denied',

    // menu
    Language.titleOfParentMenu: 'Parent',
    Language.menuOfAdmission: 'Admission',
    Language.menuOfUser: 'User',
    Language.menuOfRole: 'Role',
    Language.menuOfField: 'Field',
    Language.menuOfMenu: 'Menu',
    Language.menuOfPermission: 'Permission',
    Language.menuOfTrack: 'Track',
    Language.menuOfData: 'Data',
    Language.menuOfProduct: 'Product',
    Language.menuOfWechat: 'WeChat',
    Language.menuOfDeals: 'Deals',
    Language.menuOfCamping: 'Camping',
    Language.menuOfCarousel: 'Carousel',
    Language.menuOfSnack: 'Snack',
    Language.menuOfBarbecue: 'Barbecue',
    Language.menuOfCategory: "Category",
    Language.menuOfAdvertisement: 'Advertisement',
    Language.descriptionOfProductMenu: 'Product Management',
    Language.descriptionOfAdvertisementMenu: "Advertisement Management",
    Language.descriptionOfCategoryMenu: "Category Management",

    // field
    Language.tableOfField: 'Table',
    Language.nameOfField: 'Field',
    Language.userOfTable: 'user',
    Language.idOfUser: 'id',
    Language.descriptionOfIdOfUser: 'the ID of a user',
    Language.nameOfUser: 'name',
    Language.descriptionOfNameOfUser: 'the name of a user',
    Language.countryCodeOfUser: 'country_code',
    Language.descriptionOfCountryCodeOfUser: 'the country_code of a user',
    Language.phoneNumberOfUser: 'phone_number',
    Language.descriptionOfPhoneNumberOfUser: 'the phone_number of a user',
    Language.statusOfUser: 'status',
    Language.descriptionOfStatusOfUser: 'the status of a user',
    Language.createdAtOfUser: 'created_at',
    Language.descriptionOfCreatedAtOfUser: 'the created_at of a user',

    // permission
    Language.signIn: 'Sign In',
    Language.fetchMenuListOfCondition: 'Fetch Menu List',
    Language.fetchUserListOfCondition: 'Fetch User List',
    Language.fetchRoleListOfCondition: 'Fetch Role List',
    Language.fetchPermissionListOfCondition: 'Fetch Permission List',
    Language.insertUserRecord: 'Insert User',
    Language.softDeleteUserRecord: 'Remove User',
    Language.updateUserRecord: 'Update User',
    Language.managementOfUsers: 'The management of users',
    Language.managementOfRoles: 'The management of roles',
    Language.managementOfMenus: 'The management of menus',
    Language.managementOfPermissions: 'The management of permissions',
    Language.managementOfFields: 'The management of fields',
    Language.managementOfTracks: 'The management of tracks',

    // role
    Language.titleOfRole: 'Role',
    Language.rankOfRole: 'Rank',
    Language.departmentOfRole: 'Department',
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
    Language.departmentOfBoardOfDirectors: 'Board of Directors',
    Language.departmentOfResearchAndDevelopment: 'Research and Development',
    Language.departmentOfFinanceDepartment: 'Finance Department',
    Language.departmentOfHumanResourcesDepartment: 'Human Resources Department',
    Language.departmentOfMarketingDepartment: 'Marketing Department',
    Language.departmentOfManufacturingDepartment: 'Manufacturing Department',

    // dialog
    Language.titleOfErrorNotifyDialog: 'Error',
    Language.passwordInTwoInputControlDoNotMatch: 'Password not matched',
    Language.titleOfNotification: 'Notification',
    Language.messageOfSomewhereLogin: 'Your account login somewhere.',
    Language.endDateIsBeforeBeginDate: 'The End DateTime is Before Begin DateTime',
    Language.failureOnFetchMenuListOfCondition: 'Failure on the response of menu',
    Language.noDataFailureOnFetchMenuListOfCondition: 'No menu data failure on the response of menu',
    Language.accessDeniedFailureOnFetchPermissionOfCondition: 'Access Denied',
    Language.failureWithErrorCode: 'Error Code: ',
    Language.failureWithoutErrorCode: 'Exception',
    Language.networkDisconnected: 'Network Disconnected',
    Language.networkConnected: 'Network Connected',
    Language.removeRecordSuccessfully: 'Remove Record Successfully',
    Language.updateRecordSuccessfully: 'Update Record Successfully',
    Language.insertRecordSuccessfully: 'Insert Record Successfully',
    Language.removeOperationFailure: 'Remove Operation Fail',
    Language.operationTimeout: 'Timeout',
    Language.attemptToSignIn: 'Sign In....',
    Language.attemptToInsertRecordOfProduct: 'Inert Product....',
    Language.attemptToSoftDeleteRecordOfProduct: 'Remove Product....',
    Language.attemptToUpdateRecordOfProduct: 'Update Record....',
    Language.attemptToFetchHeaderListOfOSSObjectFile: 'Fetch OSS Header....',
    Language.attemptToUploadImageList: 'Upload Image....',
    Language.attemptToInsertRecordOfAdvertisement: 'Insert Advertisement....',
    Language.attemptToSoftDeleteRecordOfAdvertisement : 'Remove Advertisement....',
    Language.attemptToRemoveListOfObjectFile: 'Remove OSS Object File....',
    Language.attemptToInsertRecordOfUser : 'Insert User....',
    Language.attemptToSoftDeleteRecordsOfUser: 'Remove User....',
    Language.attemptToUpdateRecordOfAdvertisement: 'Update Advertisement',

    // inform.notification
    Language.eventForceOffline: 'Force Offline',
    Language.messageForceOffline: 'Your account has been logon somewhere! Your have to logout immediately.',

    // Data
    Language.idOfProduct: 'ID',
    Language.nameOfProduct: 'Name',
    Language.listOfProducts: 'Product List',
    Language.importProduct: 'Import Product',
    Language.buyingPrice: "Buying Price",
    Language.vendorOfProduct: "Vendor",
    Language.statusOfProduct: "Status",
    Language.contactOfVendor: "Contact",
    Language.idOfAdvertisement: "ID",
    Language.nameOfAdvertisement: "Name",
    Language.listOfAdvertisements: "Advertisement List",
    Language.titleOfAdvertisement: "Title",
    Language.sellingPriceOfAdvertisement: "Selling Price",
    Language.placeOfOriginOfAdvertisement: "Place Of Origin",
    Language.sellingPointsOfAdvertisement: "Selling Points",
    Language.stockOfAdvertisement: "Stock",
    Language.statusOfAdvertisement: "Status",
    Language.imageOfAdvertisement: "Image",
    Language.coverImageOfAdvertisement: 'Cover',
    Language.newAdvertisement: "New Advertisement",
    Language.editAdvertisement: "Edit Advertisement",
    Language.modifyProduct: "Modify Product",
    Language.productIdIsEmpty: "Product ID is empty!",
    Language.withoutProductInfoInResponse: "Product not found",
    Language.nameOfAdvertisementIsEmpty: "Name not provided",
    Language.addSellingPointToAdvertisement: "Add Selling Point",
    Language.fillSellingPoint: "Fill Selling Point",
    Language.pressRightButtonToAddSellingPoint: "Press button to add selling point",
    Language.incorrectStockValueInController: "Illegal stock",
    Language.incorrectSellingPriceInController: "Illegal Selling Price",
    Language.needToPeekProductInfo: "Please Peek Product",
    Language.modifyAdvertisement: "Modify Advertisement",
    Language.noRecordOfProductInDatabase: "No Product Records",
    Language.noRecordsMatchedTheSearchCondition: "No Matched Records",
    Language.noRecordOfAdvertisementInDatabase: 'No Advertisement Records',

    // Product
    Language.productNameNotProvided: "Product Name Not Provided",
    Language.buyingPriceNotProvided: "Buying Price Not Provided",
    Language.vendorOfProductNotProvided: "the vendor of product not provided",
    Language.contactOfVendorNotProvided: "the contact of vendor not provided",
    Language.descriptionOfProduct: 'Product Info',

    // WeChat
    Language.titleOfPublishOfAdvertisement: 'Publish',
    Language.approveAdvertisementToGroup: "Approve",
    Language.noRecordsPublished: 'No Records Published',
    Language.rejectAdvertisementFromGroup: "Reject",
    Language.publishAdvertisementsSuccessfully: 'Publish Successfully',
    Language.advertisementIdIsEmpty: 'Advertisement ID Not Provided',
    Language.peekInfoFromProductId: "Peek",
    Language.peekInfoFromAdvertisementId: 'Peek',
    Language.illegalPhoneNumber: 'illegal phone number',
    Language.pressToAddCoverImage: 'Add Cover',
    Language.pressToAddFirstImage: 'press to add first image',
    Language.pressToAddSecondImage: 'press to add second image',
    Language.pressToAddThirdImage: 'press to add third image',
    Language.pressToAddFourthImage: 'press to add fourth image',
    Language.pressToAddFifthImage: 'press to add fifth image',
    Language.pressToModifyCoverImage: 'Modify Cover',
    Language.pressToModifyFirstImage: 'press to modify first image',
    Language.pressToModifySecondImage: 'press to modify second image',
    Language.pressToModifyThirdImage: 'press to modify third image',
    Language.pressToModifyFourthImage: 'press to modify fourth image',
    Language.pressToModifyFifthImage: 'press to modify fifth image',
    Language.pressRightButtonToAddCoverImage: 'press right button to add cover image',
    Language.pressRightButtonToAddFirstImage: 'press the right button to add first image',
    Language.pressRightButtonToAddSecondImage: 'press the right button to add second image',
    Language.pressRightButtonToAddThirdImage: 'press the right button to add third image',
    Language.pressRightButtonToAddFourthImage: 'press the right button to add fourth image',
    Language.pressRightButtonToAddFifthImage: 'press the right button to add fifth image',
    Language.pressRightButtonToAddImage: 'press right button to add image',
    Language.addImageForAdvertisement: 'Add Advertisement Image',
    Language.modifyImageOfAdvertisement: 'Modify Image of Advertisement',
    Language.titleOfInsertAdvertisementButton: 'Insert Advertisement',
    Language.urlIllegal: 'URL is illegal',
    Language.coverImageOfAdvertisementNotProvided: 'Cover Image Not Provided',
    Language.imageOfAdvertisementNotProvided: 'Image Not Provided',
    Language.operationToInsertAdvertisement: 'Insert Advertisement',
    Language.noAdvertisementAssociated: 'Advertisement Not Provided',
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
