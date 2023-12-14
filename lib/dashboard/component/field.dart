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
import '../responsive.dart';
import '../config/config.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../setup.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_field_list_of_condition.dart';
import 'package:flutter_framework/common/business/admin/fetch_field_list_of_condition.dart';

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
    print('Field.setup');
    Cache.setFieldList(FieldList([]));
    Runtime.setObserve(observe);
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("Field.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Admin.fetchFieldListOfConditionRsp) {
        fetchFieldListOfConditionHandler(body);
        curStage++;
      } else {
        print("Field.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Field.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void fetchFieldListOfConditionHandler(Map<String, dynamic> body) {
    try {
      FetchFieldListOfConditionRsp rsp = FetchFieldListOfConditionRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print('body: ${rsp.body}');
        Cache.setFieldList(FieldList.fromJson(rsp.body));
        curStage++;
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("Field.fetchFieldListOfConditionHandler failure, $e");
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
                          if (!Runtime.allow(
                            major: int.parse(Major.admin),
                            minor: int.parse(Admin.fetchFieldListOfConditionReq),
                          )) {
                            return;
                          }
                          if (nameController.text.isEmpty && tableController.text.isEmpty && roleController.text.isEmpty) {
                            fetchFieldListOfCondition(
                              from: Field.content,
                              behavior: 1,
                              field: '',
                              table: '',
                              role: '',
                            );
                            return;
                          }
                          fetchFieldListOfCondition(
                            from: Field.content,
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
