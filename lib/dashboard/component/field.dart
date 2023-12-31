import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/field_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import '../responsive.dart';
import '../config/config.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../setup.dart';
import 'package:flutter_framework/common/service/admin/protocol/fetch_field_list_of_condition.dart';
import 'package:flutter_framework/common/service/admin/business/fetch_field_list_of_condition.dart';

class Field extends StatefulWidget {
  const Field({Key? key}) : super(key: key);

  static String content = 'Field';

  @override
  State createState() => _State();
}

class _State extends State<Field> {
  bool closed = false;
  int curStage = 1;
  TextEditingController nameController = TextEditingController();
  TextEditingController tableController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      } else {
        if (!Runtime.getConnectivity()) {
          curStage++;
          return;
        }
      }
    }
  }

  void navigate(String page) {
    if (!closed) {
      closed = true;
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          print('Field.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    // print('Field.setup');
    Cache.setFieldList(FieldList([]));
    Runtime.setObserve(observe);
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
        from: Field.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchFieldListOfConditionRsp) {
        fetchFieldListOfConditionHandler(major: major, minor: minor, body: body);
        curStage++;
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Field.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Field.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void fetchFieldListOfConditionHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchFieldListOfConditionHandler';
    try {
      FetchFieldListOfConditionRsp rsp = FetchFieldListOfConditionRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Field.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Cache.setFieldList(FieldList.fromJson(rsp.getBody()));
        curStage++;
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)} ${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Field.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  @override
  void dispose() {
    // print('Field.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('Field.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var caller = 'build';
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            return ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.nameOfField),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: tableController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.tableOfField),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        controller: roleController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.titleOfRole),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isEmpty && tableController.text.isEmpty && roleController.text.isEmpty) {
                            fetchFieldListOfCondition(
                              from: Field.content,
                              caller: '$caller.fetchFieldListOfCondition',
                              behavior: 1,
                              field: '',
                              table: '',
                              role: '',
                            );
                            return;
                          }
                          fetchFieldListOfCondition(
                            from: Field.content,
                            caller: '$caller.fetchFieldListOfCondition',
                            behavior: 2,
                            field: nameController.text,
                            table: tableController.text,
                            role: roleController.text,
                          );
                        },
                        child: Text(
                          Translator.translate(Language.titleOfSearch),
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Cache.setFieldList(FieldList([]));
                          nameController.text = '';
                          tableController.text = '';
                          roleController.text = '';
                          curStage++;
                        },
                        child: Text(
                          Translator.translate(Language.reset),
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                Spacing.addVerticalSpace(20),
                PaginatedDataTable(
                  source: Source(context),
                  header: Text(Translator.translate(Language.fieldList)),
                  columns: [
                    DataColumn(label: Text(Translator.translate(Language.nameOfField))),
                    DataColumn(label: Text(Translator.translate(Language.tableOfField))),
                    DataColumn(label: Text(Translator.translate(Language.description))),
                  ],
                  columnSpacing: 60,
                  horizontalMargin: 10,
                  rowsPerPage: 5,
                  showCheckboxColumn: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Source extends DataTableSource {
  BuildContext context;
  FieldList fieldList = Cache.getFieldList();

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => fieldList.getLength();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(Translator.translate(fieldList.getBody()[index].getName()))),
        DataCell(Text(Translator.translate(fieldList.getBody()[index].getTable()))),
        DataCell(Text(Translator.translate(fieldList.getBody()[index].getDescription()))),
      ],
    );
  }
}
