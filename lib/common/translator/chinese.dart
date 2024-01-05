import 'package:flutter_framework/common/translator/language.dart';

class Chinese {
  static const String _name = 'Chinese';
  static Map<String, String> model = {
    Language.titleOfSearch: '查询',
    Language.reset: '重置',
    Language.fPhoneNumber: '手机号码',
    Language.fCountryCode: '国家地区码',
    Language.fName: '姓名',
    Language.fStatus: '状态',
    Language.fCreatedAt: '创建时间',
    Language.roleList: '角色列表',
    Language.permissionList: '权限列表',
    Language.menuList: '菜单列表',
    Language.operation: '操作',
    Language.cancel: '取消',
    Language.next: '下一个',
    Language.back: '上一个',
    Language.confirm: "确定",
    Language.enable: '启用',
    Language.disable: '停用',
    Language.china: '中国',
    Language.philipine: '菲律宾',
    Language.password: '密码',
    Language.confirmPassword: '确认密码',
    Language.dashboard: '通用后台管理系统',
    Language.ok: '确定',
    Language.viewPermissionList: '查看权限列表',
    Language.viewMenuList: '查看菜单列表',
    Language.viewRoleList: '查看角色列表',
    Language.update: '更新',
    Language.remove: '删除',
    Language.removing: '删除记录',
    Language.confirmYourDeletion: '确认删除?',
    Language.titleOfPermission: '权限',
    Language.major: '主业务号',
    Language.minor: '次业务号',
    Language.subMenu: '菜单',
    Language.titleOfOperator: '操作人',
    Language.request: '请求',
    Language.response: '应答',
    Language.operationTimestamp: '操作时间',
    Language.operationLog: '操作日志列表',
    Language.fieldList: '字段列表',
    Language.tMenu: '菜单',
    Language.titleOfBeginDate: '开始日期',
    Language.titleOfEndDate: '结束日期',

    // user
    Language.newUser: '新增用户',
    Language.userList: '用户列表',
    Language.removeUser: '删除用户',
    Language.modifyUser: '更新用户资料',
    Language.nameOfUserNotProvided: "用户名未提供",
    Language.passwordOfUserNotProvided: "密码为空",
    Language.twoPasswordNotEqual: "两次输入的密码不一致",
    Language.phoneNumberNotProvided: "手机号码为空",

    // language
    Language.languageOfChinese: '简体中文',
    Language.languageOfEnglish: '英文',

    // common
    Language.description: '描述',
    Language.valueOfNull: '',
    Language.loading: "加载中",
    Language.clickToView: "点击查看",
    Language.titleOfRefreshOperation: '刷新',
    Language.accessDenied: '没有权限',

    // menu
    Language.titleOfParentMenu: '父级菜单',
    Language.menuOfAdmission: '管理',
    Language.menuOfUser: '用户管理',
    Language.menuOfRole: '角色管理',
    Language.menuOfField: '字段管理',
    Language.menuOfMenu: '菜单管理',
    Language.menuOfPermission: '权限管理',
    Language.menuOfTrack: '操作日志',
    Language.menuOfData: '数据管理',
    Language.menuOfProduct: '商品',
    Language.menuOfWechat: '微信广告',
    Language.menuOfDeals: '今日特价',
    Language.menuOfCamping: '露营专享',
    Language.menuOfCarousel: '首页轮播',
    Language.menuOfSnack: '畅销零食',
    Language.menuOfBarbecue: '烧烤必备',
    Language.menuOfCategory: "类目广告",
    Language.menuOfAdvertisement: '广告',
    Language.descriptionOfProductMenu: '商品管理',
    Language.descriptionOfAdvertisementMenu: "广告管理",
    Language.descriptionOfCategoryMenu: "类目管理",

    // field
    Language.tableOfField: '数据表',
    Language.nameOfField: '字段',
    Language.userOfTable: 'user',
    Language.idOfUser: 'id',
    Language.descriptionOfIdOfUser: '用户ID',
    Language.nameOfUser: 'name',
    Language.descriptionOfNameOfUser: '姓名',
    Language.countryCodeOfUser: 'country_code',
    Language.descriptionOfCountryCodeOfUser: '国家地区码',
    Language.phoneNumberOfUser: 'phone_number',
    Language.descriptionOfPhoneNumberOfUser: '电话号码',
    Language.statusOfUser: 'status',
    Language.descriptionOfStatusOfUser: '状态',
    Language.createdAtOfUser: 'created_at',
    Language.descriptionOfCreatedAtOfUser: '创建日期',

    // permission
    Language.signIn: '登入系统',
    Language.fetchMenuListOfCondition: '获取菜单列表',
    Language.fetchUserListOfCondition: '获取用户列表',
    Language.fetchRoleListOfCondition: '获取角色列表',
    Language.fetchPermissionListOfCondition: '获取权限列表',
    Language.insertUserRecord: '新增用户',
    Language.softDeleteUserRecord: '删除用户',
    Language.updateUserRecord: '更新用户',
    Language.managementOfUsers: '用户管理',
    Language.managementOfRoles: '角色管理',
    Language.managementOfMenus: '菜单管理',
    Language.managementOfPermissions: '权限管理',
    Language.managementOfFields: '字段管理',
    Language.managementOfTracks: '日志管理',

    // role
    Language.titleOfRole: '角色',
    Language.rankOfRole: '级别',
    Language.departmentOfRole: '部门',
    Language.administrator: '系统管理员',
    Language.rdManager: '研发部主管',
    Language.softwareEngineer: '软件工程师',
    Language.hardwareEngineer: '硬件工程师',
    Language.financeManger: '财务部主管',
    Language.purchasingSpecialist: '采购专员',
    Language.accountingSpecialist: '财务专员',
    Language.hrManger: '人事部主管',
    Language.hrSpecialist: '人事行政专员',
    Language.marketingManger: '市场部主管',
    Language.salesSpecialist: '销售专员',
    Language.manufacturingManger: '生产部主管',
    Language.productionSpecialist: '生产线专员',
    Language.descriptionOfAdministrator: '董事会主席',
    Language.descriptionOfRDManager: '研发部负责人，管理 软件与硬件 相关职能',
    Language.descriptionOfSoftwareEngineer: '研发部门-软件工程师',
    Language.descriptionOfHardwareEngineer: '研发部门-硬件工程师',
    Language.descriptionOfFinanceManger: '财务部门负责人',
    Language.descriptionOfPurchasingSpecialist: '财务部门-采购专员',
    Language.descriptionOfAccountingSpecialist: '财务部门-会计专员',
    Language.descriptionOfHRManger: '人事部门负责人',
    Language.descriptionOfHRSpecialist: '人事部-人事行政专员',
    Language.descriptionOfMarketingManger: '市场部负责人',
    Language.descriptionOfSalesSpecialist: '市场部-销售专员',
    Language.descriptionOfManufacturingManger: '生产部门负责人',
    Language.descriptionOfProductionSpecialist: '生产部-生产线专员',
    Language.departmentOfBoardOfDirectors: '董事会',
    Language.departmentOfResearchAndDevelopment: '研发部',
    Language.departmentOfFinanceDepartment: '财务部',
    Language.departmentOfHumanResourcesDepartment: '人事部',
    Language.departmentOfMarketingDepartment: '市场部',
    Language.departmentOfManufacturingDepartment: '生产部',

    // dialog
    Language.titleOfErrorNotifyDialog: '错误提示',
    Language.passwordInTwoInputControlDoNotMatch: '两次输入的密码不一致',
    Language.titleOfNotification: '温馨提醒: ',
    Language.messageOfSomewhereLogin: '您的帐号已在别处登录.',
    Language.endDateIsBeforeBeginDate: '结束日期在开始日期之前',
    Language.failureOnFetchMenuListOfCondition: '获取菜单数据失败',
    Language.noDataFailureOnFetchMenuListOfCondition: '没有菜单数据',
    Language.accessDeniedFailureOnFetchPermissionOfCondition: '拒绝访问',
    Language.failureWithErrorCode: '错误代码: ',
    Language.failureWithoutErrorCode: '程序异常',
    Language.networkDisconnected: '网络已断开',
    Language.networkConnected: '网络已连接',
    Language.removeRecordSuccessfully: '删除成功',
    Language.updateRecordSuccessfully: '更新成功',
    Language.insertRecordSuccessfully: '插入成功',
    Language.removeOperationFailure: '删除失败',
    Language.operationTimeout: '超时',
    Language.attemptToSignIn: '尝试登录系统....',
    Language.attemptToInsertRecordOfProduct: '尝试插入商品记录....',
    Language.attemptToSoftDeleteRecordOfProduct: '尝试删除商品记录....',
    Language.attemptToUpdateRecordOfProduct: '尝试更新商品记录....',
    Language.attemptToFetchHeaderListOfOSSObjectFile: '尝试获取OSS校验头....',
    Language.attemptToUploadImageList: '尝试上传图片至OSS....',
    Language.attemptToInsertRecordOfAdvertisement: '尝试插入广告记录....',
    Language.attemptToSoftDeleteRecordOfAdvertisement: '尝试删除广告记录',
    Language.attemptToRemoveListOfObjectFile: '尝试删除OSS图片文件',
    Language.attemptToInsertRecordOfUser: '尝试插入用户记录',
    Language.attemptToSoftDeleteRecordsOfUser: '尝试删除用户记录....',

    // inform.notification
    Language.eventForceOffline: '强制下线',
    Language.messageForceOffline: '帐号在异地登录, 当前帐号被强制下线.',

    // Data
    Language.idOfProduct: '商品ID',
    Language.nameOfProduct: '商品名称',
    Language.listOfProducts: '商品列表',
    Language.importProduct: "录入商品",
    Language.buyingPrice: "进货价",
    Language.vendorOfProduct: "供应商",
    Language.statusOfProduct: "状态",
    Language.contactOfVendor: "联系方式",
    Language.idOfAdvertisement: "广告ID",
    Language.nameOfAdvertisement: "广告名称",
    Language.listOfAdvertisements: "广告列表",
    Language.titleOfAdvertisement: "广告标语",
    Language.sellingPriceOfAdvertisement: "售价",
    Language.placeOfOriginOfAdvertisement: "产地",
    Language.sellingPointsOfAdvertisement: "卖点",
    Language.stockOfAdvertisement: "库存",
    Language.statusOfAdvertisement: "状态",
    Language.imageOfAdvertisement: "广告图",
    Language.coverImageOfAdvertisement: '封面图',
    Language.newAdvertisement: "新增广告",
    Language.editAdvertisement: "编辑广告",
    Language.modifyProduct: "更新商品信息",
    Language.productIdIsEmpty: "商品ID为空",
    Language.withoutProductInfoInResponse: "未找到商品信息",
    Language.nameOfAdvertisementIsEmpty: "未提供广告名称",
    Language.addSellingPointToAdvertisement: "添加商品卖点",
    Language.fillSellingPoint: "请输入商品卖点",
    Language.pressRightButtonToAddSellingPoint: "点击右则按钮增加商品卖点",
    Language.incorrectStockValueInController: "库存设定有误",
    Language.incorrectSellingPriceInController: "出售价格有误",
    Language.needToPeekProductInfo: "请先确认商品信息",
    Language.modifyAdvertisement: "更新广告",
    Language.noRecordOfProductInDatabase: "数据库没有任何商品记录",
    Language.noRecordsMatchedTheSearchCondition: "未找到匹配记录",
    Language.noRecordOfAdvertisementInDatabase: '数据库没有任何广告记录',

    // Product
    Language.productNameNotProvided: "未提供商品名称",
    Language.buyingPriceNotProvided: "未提供进货价",
    Language.vendorOfProductNotProvided: "未填写供应商",
    Language.contactOfVendorNotProvided: "未填写供应商联系方式",
    Language.descriptionOfProduct: '商品描述',

    // Wechat
    Language.titleOfPublishOfAdvertisement: '发布',
    Language.approveAdvertisementToGroup: '添加广告',
    Language.noRecordsPublished: '未发布任何广告',
    Language.rejectAdvertisementFromGroup: "移除广告",
    Language.publishAdvertisementsSuccessfully: '发布成功',
    Language.advertisementIdIsEmpty: '广告ID为空',
    Language.peekInfoFromProductId: "查看商品信息",
    Language.peekInfoFromAdvertisementId: '查看广告信息',
    Language.illegalPhoneNumber: '非法的手机号码',
    Language.pressToAddCoverImage: '添加封面图',
    Language.pressToAddFirstImage: '添加第一张广告图',
    Language.pressToAddSecondImage: '添加第二张广告图',
    Language.pressToAddThirdImage: '添加第三张广告图',
    Language.pressToAddFourthImage: '添加第四张广告图',
    Language.pressToAddFifthImage: '添加第五张广告图',
    Language.pressToModifyCoverImage: '更换封面图',
    Language.pressToModifyFirstImage: '更换第一张广告图',
    Language.pressToModifySecondImage: '更换第二张广告图',
    Language.pressToModifyThirdImage: '更换第三张广告图',
    Language.pressToModifyFourthImage: '更换第四张广告图',
    Language.pressToModifyFifthImage: '更换第五张广告图',
    Language.pressRightButtonToAddCoverImage: '点击右则按钮添加封面图',
    Language.pressRightButtonToAddFirstImage: '点击右则按钮添加第一张广告图',
    Language.pressRightButtonToAddSecondImage: '点击右则按钮添加第二张广告图',
    Language.pressRightButtonToAddThirdImage: '点击右则按钮添加第三张广告图',
    Language.pressRightButtonToAddFourthImage: '点击右则按钮添加第四张广告图',
    Language.pressRightButtonToAddFifthImage: '点击右则按钮添加第五张广告图',
    Language.pressRightButtonToAddImage: '点击右则按钮添加图片',
    Language.addImageForAdvertisement: '增加广告图片',
    Language.modifyImageOfAdvertisement: '更新广告图片',
    Language.titleOfInsertAdvertisementButton: "新增",
    Language.urlIllegal: '非法的URL',
    Language.coverImageOfAdvertisementNotProvided: '未指定封面图',
    Language.imageOfAdvertisementNotProvided: '未指定商品图片',
    Language.operationToInsertAdvertisement: '新增广告',
    Language.noAdvertisementAssociated: '未关联任何广告',
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
