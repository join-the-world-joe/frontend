import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/check_permission.dart';
import 'package:flutter_framework/dashboard/business/fetch_id_list_of_good.dart';
import 'package:flutter_framework/dashboard/dialog/insert_good.dart';
import 'package:flutter_framework/dashboard/dialog/insert_user.dart';
import 'package:flutter_framework/dashboard/dialog/remove_good.dart';
import 'package:flutter_framework/dashboard/model/user_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../model/product.dart';

class Good extends StatefulWidget {
  const Good({Key? key}) : super(key: key);

  static String content = 'Good';

  @override
  State createState() => _State();
}

class _State extends State<Good> {
  bool closed = false;
  int curStage = 1;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final scrollController = ScrollController();
  var sourceContext = SourceContext();

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

  void fetchIdListOfGoodHandler(Map<String, dynamic> body) {
    try {
      FetchIdListOfGoodRsp rsp = FetchIdListOfGoodRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        sourceContext.idList = rsp.getIdList();
        curStage++;
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.getCode()}');
        return;
      }
    } catch (e) {
      print("Track.fetchIdListOfGoodHandler failure, $e");
      return;
    }
  }

  void navigate(String page) {
    if (!closed) {
      closed = true;
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          print('Good.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    Cache.setUserList(UserList([]));
    Runtime.setObserve(observe);
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("Good.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.fetchIdListOfGoodRsp) {
        fetchIdListOfGoodHandler(body);
      } else {
        print("Good.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Good.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  @override
  void initState() {
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
            if (curStage > 0) {
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
                          controller: idController,
                          decoration: InputDecoration(
                            // border: const UnderlineInputBorder(),
                            labelText: Translator.translate(Language.idOfGood),
                          ),
                        ),
                      ),
                      Spacing.addHorizontalSpace(20),
                      SizedBox(
                        width: 110,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            // border: const UnderlineInputBorder(),
                            labelText: Translator.translate(Language.nameOfGood),
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
                              minor: int.parse(Minor.admin.fetchIdListOfGoodReq),
                            )) {
                              return;
                            }
                            if (idController.text.isEmpty && nameController.text.isEmpty) {
                              fetchIdListOfGood(
                                behavior: 1,
                                productName: "",
                                categoryId: 0,
                              );
                              return;
                            }
                            fetchIdListOfGood(
                              behavior: 2,
                              productName: nameController.text,
                              categoryId: 0,
                            );
                            return;
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
                            idController.text = '';
                            nameController.text = '';
                            sourceContext.idList = [];
                            refresh();
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
                  Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: PaginatedDataTable(
                      controller: scrollController,
                      actions: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            showInsertGoodDialog(context);
                          },
                          label: Text(
                            Translator.translate(Language.importGood),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                      source: Source(context, sourceContext),
                      header: Text(Translator.translate(Language.listOfGoods)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.idOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.buyingPrice))),
                        DataColumn(label: Text(Translator.translate(Language.vendorOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.statusOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.contactOfVendor))),
                        DataColumn(label: Text(Translator.translate(Language.description))),
                        DataColumn(label: Text(Translator.translate(Language.operation))),
                      ],
                      columnSpacing: 60,
                      horizontalMargin: 10,
                      rowsPerPage: 5,
                      showCheckboxColumn: false,
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class SourceContext {
  List<int> idList = [];
  Map<int, Product> productMap = {};
  Map<int, int> productMapStatus = {}; // null, default; >0, timestamp, requested; 100, load completed


}

class Source extends DataTableSource {
  BuildContext buildContext;
  SourceContext context;

  Source(
    this.buildContext,
    this.context,
  );

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => context.idList.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    print("getRow: $index");
    var id = Translator.translate(Language.loading);
    var name = Translator.translate(Language.loading);
    var buyingPrice = Translator.translate(Language.loading);
    var vendor = Translator.translate(Language.loading);
    var status = Translator.translate(Language.loading);
    var contact = Translator.translate(Language.loading);
    var desc = Translator.translate(Language.loading);



    return DataRow(
      selected: false,
      onSelectChanged: (selected) {
        // print('selected: $selected');
      },
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(buyingPrice)),
        DataCell(Text(vendor)),
        DataCell(Text(status)),
        DataCell(Text(contact)),
        DataCell(Text(desc)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: Translator.translate(Language.update),
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: Translator.translate(Language.remove),
                onPressed: () async {
                  await showRemoveGoodDialog(context, userList.getBody()[index]).then(
                        (value) => () {
                      // print('value: $value');
                      if (value) {
                        context.idList.removeAt(index);
                        notifyListeners();
                      }
                    }(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
