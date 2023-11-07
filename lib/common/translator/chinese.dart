import 'package:flutter_framework/common/translator/language.dart';

class Chinese {
  static const String _name = 'Chinese';
  static Map<String, String> model = {
    Language.admission: '管理',
    Language.user: '用户管理',
    Language.role: '角色管理',
    Language.field: '字段管理',
    Language.menu: '菜单管理',
    Language.permission: '权限管理',
    Language.track: '操作日志',
    Language.search: '查询',
    Language.reset: '重置',
    Language.userList: '用户列表',
    Language.fPhoneNumber: '手机号码',
    Language.fCountryCode: '国家地区码',
    Language.fName: '姓名',
    Language.fRole: '角色',
    Language.fStatus: '状态',
    Language.fCreatedAt: '创建时间',
    Language.roleList: '角色列表',
    Language.permissionList: '权限列表',
    Language.menuList: '菜单列表',
    Language.operation: '操作',
    Language.newUser: '新增用户',
    Language.cancel: '取消',
    Language.confirm: "确定",
    Language.enable: '启用',
    Language.disable: '停用',
    Language.china: '中国',
    Language.philipine: '菲律宾',
    Language.password: '密码',
    Language.confirmPassword: '确认密码',
    Language.modifyUser: '更新用户资料',
    Language.dashboard: '通用后台管理系统',
    Language.ok: '确定',
    Language.level: '等级',
    Language.description: '描述',
    Language.viewPermissionList: '查看权限列表',
    Language.viewMenuList: '查看菜单列表',
    Language.viewRoleList: '查看角色列表',
    Language.removeUser : '删除用户',
    Language.update: '更新',
    Language.remove: '删除',
    Language.confirmYourDeletion: '确认删除?',
    Language.fPermission: '权限',
    Language.major: '主业务号',
    Language.minor: '次业务号',
    Language.fMenu: '父级菜单',
    Language.subMenu: '菜单',
    Language.operator:'操作人',
    Language.request: '请求',
    Language.response: '应答',
    Language.operationTimestamp:'操作时间',
    Language.operationLog : '操作日志列表',
    Language.table: '数据表',
    Language.fField: '字段',
    Language.fieldList:'字段列表',
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
