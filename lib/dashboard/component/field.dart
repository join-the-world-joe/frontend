import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

class Field extends StatefulWidget {
  const Field({Key? key}) : super(key: key);

  static String content = 'Field';

  @override
  State createState() => _State();
}

class _State extends State<Field> {
  bool closed = false;
  int curStage = 1;

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
      if (major == Major.admin && minor == Minor.admin.fetchFieldListOfConditionRsp) {
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

  @override
  void dispose() {
    print('Field.dispose');
    super.dispose();
  }

  void debug() async {
    print('Field.debug');
  }

  @override
  void initState() {
    print('Field.initState');
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
                        // controller: _accountController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.fField),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        // controller: _accountController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.table),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 110,
                      child: TextFormField(
                        // controller: _accountController,
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
                        onPressed: () {},
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
                        onPressed: () {},
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
                    DataColumn(label: Text(Translator.translate(Language.fField))),
                    DataColumn(label: Text(Translator.translate(Language.table))),
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
  List<Widget> widgets = [];
  final List<User> _data = [];

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text('')),
        DataCell(Text('')),
        DataCell(Text('')),
      ],
    );
  }
}
