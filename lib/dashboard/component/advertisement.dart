import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/check_permission.dart';
import 'package:flutter_framework/dashboard/business/fetch_id_list_of_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/insert_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/insert_user.dart';
import 'package:flutter_framework/dashboard/dialog/remove_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/selling_point_of_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/update_advertisement.dart';
import 'package:flutter_framework/dashboard/model/user_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../model/advertisement.dart' as model;
import '../business/fetch_records_of_advertisement.dart';

class Advertisement extends StatefulWidget {
  const Advertisement({Key? key}) : super(key: key);

  static String content = 'Advertisement';

  @override
  State createState() => _State();
}

class _State extends State<Advertisement> {
  bool closed = false;
  int curStage = 1;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final scrollController = ScrollController();
  List<int> idList = [];
  Map<int, model.Advertisement> dataMap = {};
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
          print('User.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("Advertisement.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.fetchIdListOfAdvertisementRsp) {
        fetchIdListOfAdvertisementHandler(body);
      } else if (major == Major.admin && minor == Minor.admin.fetchRecordsOfAdvertisementRsp) {
        fetchRecordsOfAdvertisementHandler(body);
      } else {
        print("Advertisement.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Advertisement.observe($major-$minor).e: ${e.toString()}');
      return;
    } finally {}
  }

  void setup() {
    // print('User.setup');
    Cache.setUserList(UserList.construct(userList: []));
    Runtime.setObserve(observe);
  }

  void resetSource() {
    idList = [];
    dataMap = {};
    datetimeMap = {};
    boolMap = {};
    curStage++;
  }


  void fetchIdListOfAdvertisementHandler(Map<String, dynamic> body) {
    try {
      FetchIdListOfAdvertisementRsp rsp = FetchIdListOfAdvertisementRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        print("Advertisement.fetchIdListOfGoodHandler.idList: ${rsp.getIdList()}");
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
      print("Advertisement.fetchIdListOfGoodHandler failure, $e");
      return;
    }
  }

  void fetchRecordsOfAdvertisementHandler(Map<String, dynamic> body) {
    try {
      FetchRecordsOfAdvertisementRsp rsp = FetchRecordsOfAdvertisementRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        print('advertisement map: ${rsp.advertisementMap.toString()}');
        if (rsp.advertisementMap.isEmpty) {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.noRecordsMatchedTheSearchCondition),
          );
          return;
        }
        if (idList.isEmpty) {
          rsp.getAdvertisementMap().forEach((key, value) {
            idList.add(key);
            dataMap[key] = value;
            boolMap[key] = true;
          });
        }
        rsp.getAdvertisementMap().forEach((key, value) {
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
      print("Advertisement.fetchRecordsOfGoodHandler failure, $e");
      return;
    } finally {}
  }

  void refresh() {
    // print('User.refresh');
    setState(() {});
  }

  @override
  void dispose() {
    // print('User.dispose');
    closed = true;
    super.dispose();
  }

  @override
  void initState() {
    // print('User.initState');
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
                            labelText: Translator.translate(Language.idOfAdvertisement),
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
                            labelText: Translator.translate(Language.nameOfAdvertisement),
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
                              fetchIdListOfAdvertisement(
                                behavior: 1,
                                advertisementName: "",
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
                              fetchRecordsOfAdvertisement(advertisementIdList: [int.parse(idController.text)]);
                              return;
                            }
                            if (nameController.text.isNotEmpty) {
                              if (!Runtime.allow(
                                major: int.parse(Major.admin),
                                minor: int.parse(Minor.admin.fetchIdListOfAdvertisementReq),
                              )) {
                                return;
                              }
                              resetSource();
                              fetchIdListOfAdvertisement(
                                behavior: 2,
                                advertisementName: nameController.text,
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
                            showInsertAdvertisementDialog(context);
                          },
                          label: Text(
                            Translator.translate(Language.newAdvertisement),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                      source: Source(context, idList, dataMap, datetimeMap, boolMap),
                      header: Text(Translator.translate(Language.listOfAdvertisements)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.idOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.idOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.titleOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.sellingPriceOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.placeOfOriginOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.sellingPointsOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.stockOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.imageOfAdvertisement))),
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

class Source extends DataTableSource {
  List<int> idList;
  List<int> requestIdList = [];
  Map<int, model.Advertisement> dataMap;
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
    var idOfAdvertisement = Translator.translate(Language.loading);
    var idOfGood = Translator.translate(Language.loading);
    var nameOfAdvertisement = Translator.translate(Language.loading);
    var titleOfAdvertisement = Translator.translate(Language.loading);
    var sellingPriceOfAdvertisement = Translator.translate(Language.loading);
    var placeOfOrigin = Translator.translate(Language.loading);
    List<String> sellingPoints = [];
    var stock = Translator.translate(Language.loading);
    var url = Translator.translate(Language.loading);
    var description = Translator.translate(Language.loading);
    var operation = Translator.translate(Language.loading);
    var status = Translator.translate(Language.loading);

    var key = idList[index];

    if (boolMap.containsKey(key)) {
      // fetch row finished
      if (dataMap.containsKey(key)) {
        idOfAdvertisement = dataMap[key]!.getId().toString();
        nameOfAdvertisement = dataMap[key]!.getName();
        titleOfAdvertisement = dataMap[key]!.getTitle();
        sellingPriceOfAdvertisement = dataMap[key]!.getSellingPrice().toString();
        placeOfOrigin = dataMap[key]!.getPlaceOfOrigin();
        stock = dataMap[key]!.getStock().toString();
        status = dataMap[key]!.getStatus().toString();
        idOfGood = dataMap[key]!.getProductId().toString();
        url = dataMap[key]!.getUrl().toString();
        description = dataMap[key]!.getDescription().toString();
        sellingPoints = dataMap[key]!.getSellingPoints();
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
        fetchRecordsOfAdvertisement(advertisementIdList: requestIdList);
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
        DataCell(Text(idOfAdvertisement)),
        DataCell(Text(idOfGood)),
        DataCell(Text(nameOfAdvertisement)),
        DataCell(Text(titleOfAdvertisement)),
        DataCell(Text(sellingPriceOfAdvertisement)),
        DataCell(Text(placeOfOrigin)),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              //   showRoleListOfUserDialog(context, _data[index]);
              showSellingPointOfAdvertisementDialog(buildContext, idOfAdvertisement, sellingPoints);
            },
          ),
        ),
        DataCell(Text(stock)),
        DataCell(Text(url)),
        DataCell(Text(description)),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: Translator.translate(Language.update),
                onPressed: () async {
                  showUpdateAdvertisementDialog(
                    buildContext,
                    model.Advertisement.construct(
                      id: int.parse(idOfAdvertisement),
                      name: nameOfAdvertisement,
                      title: titleOfAdvertisement,
                      placeOfOrigin: placeOfOrigin,
                      sellingPoints: sellingPoints,
                      url: url,
                      sellingPrice: int.parse(sellingPriceOfAdvertisement),
                      description: description,
                      status: int.parse(status),
                      stock: int.parse(stock),
                      productId: int.parse(idOfGood),
                    ),
                  ).then((value) {
                    if (value) {
                      fetchRecordsOfAdvertisement(advertisementIdList: [int.parse(idOfAdvertisement)]);
                      notifyListeners();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: Translator.translate(Language.remove),
                onPressed: () async {
                  await showRemoveAdvertisementDialog(buildContext, int.parse(idOfAdvertisement), nameOfAdvertisement).then(
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
