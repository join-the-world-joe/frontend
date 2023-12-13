import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/dialog/insert_good.dart';
import 'package:flutter_framework/dashboard/dialog/insert_user.dart';
import 'package:flutter_framework/dashboard/dialog/remove_good.dart';
import 'package:flutter_framework/dashboard/dialog/update_good.dart';
import 'package:flutter_framework/dashboard/model/user_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../model/product.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_id_list_of_good.dart';
import 'package:flutter_framework/common/business/admin/fetch_id_list_of_good.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_good.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_good.dart';

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
  final vendorController = TextEditingController();
  final scrollController = ScrollController();
  List<int> idList = [];
  Map<int, Product> dataMap = {};
  Map<int, DateTime> datetimeMap = {};
  Map<int, bool> boolMap = {};

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
          print('Good.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void fetchIdListOfGoodHandler(Map<String, dynamic> body) {
    try {
      FetchIdListOfGoodRsp rsp = FetchIdListOfGoodRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        print("Good.fetchIdListOfGoodHandler.idList: ${rsp.getIdList()}");
        if (rsp.getIdList().isEmpty) {
          if (rsp.getBehavior() == 1) {
            showMessageDialog(
              context,
              Translator.translate(Language.titleOfNotification),
              Translator.translate(Language.noRecordOfGoodInDatabase),
            );
            return;
          } else if (rsp.getBehavior() == 2) {
            showMessageDialog(
              context,
              Translator.translate(Language.titleOfNotification),
              Translator.translate(Language.noRecordsMatchedTheSearchCondition),
            );
            return;
          } else {
            showMessageDialog(
              context,
              Translator.translate(Language.titleOfNotification),
              '${Translator.translate(Language.failureWithErrorCode)} -1',
            );
            return;
          }
        }
        idList = rsp.getIdList();
        curStage++;
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      print("Good.fetchIdListOfGoodHandler failure, $e");
      return;
    }
  }

  void fetchRecordsOfGoodHandler(Map<String, dynamic> body) {
    try {
      FetchRecordsOfGoodRsp rsp = FetchRecordsOfGoodRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        print('product map: ${rsp.getDataMap().toString()}');
        if (rsp.getDataMap().isEmpty) {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.noRecordsMatchedTheSearchCondition),
          );
          return;
        }
        if (idList.isEmpty) {
          rsp.getDataMap().forEach((key, value) {
            idList.add(key);
            dataMap[key] = value;
            boolMap[key] = true;
          });
        }

        rsp.getDataMap().forEach((key, value) {
          dataMap[key] = value;
          boolMap[key] = true;
        });

        curStage++;
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      print("Good.fetchRecordsOfGoodHandler failure, $e");
      return;
    } finally {}
  }

  void resetSource() {
    idList = [];
    dataMap = {};
    datetimeMap = {};
    boolMap = {};
    curStage++;
  }

  void setup() {
    Cache.setUserList(UserList.construct(userList: []));
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
      } else if (major == Major.admin && minor == Minor.admin.fetchRecordsOfGoodRsp) {
        fetchRecordsOfGoodHandler(body);
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
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            LengthLimitingTextInputFormatter(11),
                          ],
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
                            if (idController.text.isEmpty && nameController.text.isEmpty) {
                              if (!Runtime.allow(
                                major: int.parse(Major.admin),
                                minor: int.parse(Minor.admin.fetchIdListOfGoodReq),
                              )) {
                                return;
                              }
                              resetSource();
                              fetchIdListOfGood(
                                behavior: 1,
                                productName: "",
                                categoryId: 0,
                              );
                              return;
                            }
                            if (idController.text.isNotEmpty) {
                              if (!Runtime.allow(
                                major: int.parse(Major.admin),
                                minor: int.parse(Minor.admin.fetchRecordsOfGoodReq),
                              )) {
                                return;
                              }
                              resetSource();
                              fetchRecordsOfGood(productIdList: [int.parse(idController.text)]);
                              return;
                            }
                            if (nameController.text.isNotEmpty) {
                              if (!Runtime.allow(
                                major: int.parse(Major.admin),
                                minor: int.parse(Minor.admin.fetchIdListOfGoodReq),
                              )) {
                                return;
                              }
                              resetSource();
                              fetchIdListOfGood(
                                behavior: 2,
                                productName: nameController.text,
                                categoryId: 0,
                              );
                              return;
                            }
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
                            idList = [];
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
                      source: Source(context, idList, dataMap, datetimeMap, boolMap),
                      header: Text(Translator.translate(Language.listOfGoods)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.idOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.buyingPrice))),
                        DataColumn(label: Text(Translator.translate(Language.vendorOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.contactOfVendor))),
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

class Source extends DataTableSource {
  List<int> idList;
  List<int> requestIdList = [];
  Map<int, Product> dataMap;
  Map<int, DateTime> datetimeMap;
  Map<int, bool> boolMap;
  BuildContext buildContext;

  Source(
    this.buildContext,
    this.idList,
    this.dataMap,
    this.datetimeMap,
    this.boolMap,
  );

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => () {
        print("length: ${idList.length}");
        return idList.length;
      }();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    print("getRow: $index");
    var id = Translator.translate(Language.loading);
    var name = Translator.translate(Language.loading);
    var buyingPrice = Translator.translate(Language.loading);
    var vendor = Translator.translate(Language.loading);
    var contact = Translator.translate(Language.loading);

    var key = idList[index];

    if (boolMap.containsKey(key)) {
      // fetch row finished
      if (dataMap.containsKey(key)) {
        id = dataMap[key]!.getId().toString();
        name = dataMap[key]!.getName();
        buyingPrice = dataMap[key]!.getBuyingPrice().toString();
        vendor = dataMap[key]!.getVendor();
        contact = dataMap[key]!.getContact();
      } else {
        print("unknown error: dataMap.containsKey(key) == false");
      }
    } else {
      if (datetimeMap.containsKey(key)) {
        // item requested
        print("key: ${key}, datetime: ${datetimeMap[key]}");
      }
      {
        // item not requested
        requestIdList = [];
        requestIdList.add(key);
        if (index % 5 == 0 || index == 0) {
          for (var i = index + 1; i < index + 5; i++) {
            if (i >= idList.length) {
              break;
            }
            requestIdList.add(idList[i]);
          }
        }
        fetchRecordsOfGood(productIdList: requestIdList);
        print("requestIdList: $requestIdList");
        for (var i = 0; i < requestIdList.length; i++) {
          datetimeMap[i] = DateTime.now();
        }
      }
    }

    return DataRow(
      selected: false,
      onSelectChanged: (selected) {
        // print('selected: $selected');
      },
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(Convert.intStringDivide10toDoubleString(buyingPrice))),
        DataCell(Text(vendor)),
        DataCell(Text(contact)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: Translator.translate(Language.update),
                onPressed: () async {
                  if (id.compareTo(Translator.translate(Language.loading)) == 0) {
                    return;
                  }
                  showUpdateGoodDialog(
                    buildContext,
                    Product.construct(
                      id: int.parse(id),
                      name: name,
                      buyingPrice: int.parse(buyingPrice),
                      vendor: vendor,
                      createdAt: "",
                      contact: contact,
                      updatedAt: "",
                    ),
                  ).then((value) {
                    if (value) {
                      print("notifyListeners");
                      fetchRecordsOfGood(productIdList: [int.parse(id)]);
                      notifyListeners();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: Translator.translate(Language.remove),
                onPressed: () async {
                  await showRemoveGoodDialog(buildContext, int.parse(id), name, vendor).then(
                    (value) => () {
                      // print('value: $value');
                      if (value) {
                        idList.removeAt(index);
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
