import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/business/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_user.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_user/insert_record_of_user_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_user/insert_record_of_user_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_user_record.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../../../../dashboard/config/config.dart';

Future<void> showInsertRecordOfUserDialog(BuildContext context) async {
  String? countryCode;
  bool closed = false;
  int curStage = 0;
  String from = 'showInsertRecordOfUserDialog';
  RoleList wholeRoleList;
  Map<Role, bool> roleStatus = {};
  RoleList roleList = RoleList([]);
  bool bAccountAlreadyExist = false;
  int status = int.parse('1');

  InsertRecordOfUserProgress? insertRecordOfUserProgress;

  var oriObserve = Runtime.getObserve();
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var verifyPasswordController = TextEditingController();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showInsertUserDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void fetchRoleListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRoleListOfConditionHandler';
    try {
      var rsp = FetchRoleListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        wholeRoleList = RoleList.fromJson(rsp.getBody());
        for (var i = 0; i < wholeRoleList.getBody().length; i++) {
          roleStatus[wholeRoleList.getBody()[i]] = false;
          for (var j = 0; j < roleList.getBody().length; j++) {
            if (roleList.getBody()[j].getName() == wholeRoleList.getBody()[i].getName()) {
              roleStatus[wholeRoleList.getBody()[i]] = true;
              break;
            }
          }
        }
        curStage++;
        return;
      } else if (rsp.getCode() == Code.accessDenied) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.accessDenied),
        );
        curStage = -1;
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
        curStage = -1;
        return;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
    }
  }

  void insertUserRecordHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'insertUserRecordHandler';
    try {
      var rsp = InsertRecordOfUserRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      insertRecordOfUserProgress!.respond(rsp);
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void observe(PacketClient packet) {
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.insertRecordOfUserRsp) {
        insertUserRecordHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.fetchRoleListOfConditionRsp) {
        fetchRoleListOfConditionHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: from,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var caller = 'builder';
      fetchRoleListOfCondition(
        from: from,
        caller: caller,
        behavior: 1,
        userId: 0,
        roleNameList: [''],
      );
      return AlertDialog(
        title: Text(Translator.translate(Language.newUser)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.nameOfUserNotProvided));
                return;
              }
              if (passwordController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.passwordOfUserNotProvided));
                return;
              }
              if (passwordController.text != verifyPasswordController.text) {
                await showWarningDialog(context, Translator.translate(Language.twoPasswordNotEqual));
                return;
              }
              if (phoneNumberController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.phoneNumberNotProvided));
                return;
              }

              List<String> roleList = () {
                List<String> roleList = [];
                roleStatus.forEach(
                  (key, value) {
                    if (value) {
                      roleList.add(key.getName());
                    }
                  },
                );
                print('selected: $roleList');
                return roleList;
              }();
              if (insertRecordOfUserProgress == null) {
                var step = InsertRecordOfUserStep.construct(
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                  countryCode: countryCode ?? '86',
                  status: status,
                  password: Runtime.rsa.encrypt(passwordController.text),
                  roleList: roleList,
                );
                insertRecordOfUserProgress = InsertRecordOfUserProgress.construct(
                  step: step,
                );
                insertRecordOfUserProgress!.show(context: context).then((value) {
                  if (value == Code.oK) {
                    showMessageDialog(
                      context,
                      Translator.translate(Language.titleOfNotification),
                      Translator.translate(Language.insertRecordSuccessfully),
                    ).then(
                      (value) {
                        Navigator.pop(context, null);
                      },
                    );
                  } else {
                    showMessageDialog(
                      context,
                      Translator.translate(Language.titleOfNotification),
                      '${Translator.translate(Language.failureWithErrorCode)} ${step.getCode()}',
                    );
                  }
                  insertRecordOfUserProgress = null;
                });
              }
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          // Spacing.AddVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            return SizedBox(
              width: 450,
              height: 435,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 350,
                      child: Row(
                        children: [
                          Spacing.addHorizontalSpace(85),
                          Text(Translator.translate(Language.enable)),
                          Radio<int?>(
                              value: 1,
                              groupValue: status,
                              onChanged: (b) {
                                status = b!;
                                curStage++;
                                // print("status: $b");
                              }),
                          Spacing.addHorizontalSpace(50),
                          Text(Translator.translate(Language.disable)),
                          Radio<int?>(
                            value: 2,
                            groupValue: status,
                            onChanged: (b) {
                              status = b!;
                              curStage++;
                              // print("status: $b");
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          Translator.translate(Language.fCountryCode),
                        ),
                        isExpanded: true,
                        value: countryCode,
                        items: [
                          DropdownMenuItem<String>(
                            value: '86',
                            child: Text(Translator.translate(Language.china)),
                          ),
                          DropdownMenuItem<String>(
                            value: '63',
                            child: Text(Translator.translate(Language.philipine)),
                          ),
                        ],
                        onChanged: (countryCode) {
                          countryCode = countryCode ?? '';
                          curStage++;
                        },
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.fPhoneNumber),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.fName),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.password),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: true,
                        controller: verifyPasswordController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.confirmPassword),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    _buildRoleChip(Translator.translate(Language.titleOfRole)),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 380,
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: () {
                                List<Widget> widgets = [];
                                if (roleStatus.isEmpty) {
                                  return widgets;
                                }
                                widgets = [];
                                roleStatus.forEach(
                                  (key, value) {
                                    widgets.add(
                                      InputChip(
                                        tooltip: Translator.translate(key.getDescription()),
                                        padding: const EdgeInsets.all(8.0),
                                        labelPadding: const EdgeInsets.all(2.0),
                                        selectedColor: Colors.green,
                                        selected: roleStatus[key]!,
                                        onPressed: () {
                                          roleStatus[key] = !roleStatus[key]!;
                                          curStage++;
                                        },
                                        label: Text(Translator.translate(key.getName())),
                                      ),
                                    );
                                  },
                                );
                                return widgets;
                              }(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).then(
    (value) {
      closed = true;
      Runtime.setObserve(oriObserve);
    },
  );
}

Chip _buildRoleChip(String label) {
  return Chip(
    labelPadding: const EdgeInsets.all(2.0),
    label: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.cyan,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: const EdgeInsets.all(8.0),
  );
}
