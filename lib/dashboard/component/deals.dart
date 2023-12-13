import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/common/business/advertisement/fetch_id_list_of_ad_of_deals.dart';
import 'package:flutter_framework/common/business/advertisement/fetch_records_of_ad_of_deals.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_id_list_of_ad_of_deals.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_records_of_ad_of_deals.dart';
import 'dart:async';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/dialog/approve_advertisement_of_ad_of_deals.dart';
import 'package:flutter_framework/dashboard/dialog/reject_advertisement_of_ad_of_deals.dart';
import 'package:flutter_framework/dashboard/dialog/selling_point_of_advertisement.dart';
import 'package:flutter_framework/dashboard/model/ad_of_deals.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/common/protocol/advertisement/fetch_version_of_ad_of_deals.dart';

class Deals extends StatefulWidget {
  const Deals({Key? key}) : super(key: key);

  static String content = 'Deals';

  @override
  State createState() => _State();
}

class _State extends State<Deals> {
  bool closed = false;
  int curStage = 1;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final vendorController = TextEditingController();
  final scrollController = ScrollController();
  List<int> idList = [];
  Map<int, ADOfDeals> dataMap = {};
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
          print('Deals.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void insertRecordOfADOfDealsHandler(Map<String, dynamic> body) {
    try {
      InsertRecordOfADOfDealsRsp rsp = InsertRecordOfADOfDealsRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.publishAdvertisementsSuccessfully),
        );
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
      }
    } catch (e) {
      print("Deals.insertRecordOfADOfDealsHandler failure, $e");
    } finally {}
  }

  void fetchVersionOfADOfDealsHandler(Map<String, dynamic> body) {
    try {
      FetchVersionOfADOfDealsRsp rsp = FetchVersionOfADOfDealsRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        print('fetchVersionOfADOfDealsHandler ok, ${rsp.getVersion()}');
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
      }
    } catch (e) {
      print("Deals.fetchVersionOfADOfDealsHandler failure, $e");
    } finally {}
  }

  void fetchIdListOfADOfDealsHandler(Map<String, dynamic> body) {
    try {
      FetchIdListOfADOfDealsRsp rsp = FetchIdListOfADOfDealsRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        print("Deals.fetchIdListOfADOfDealsHandler.idList: ${rsp.getIdList()}");
        if (rsp.getIdList().isEmpty) {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.noRecordsOfADOfDeals),
          );
          return;
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
      print("Deals.fetchIdListOfGoodHandler failure, $e");
      return;
    }
  }

  void fetchRecordsOfADOfDealsHandler(Map<String, dynamic> body) {
    try {
      FetchRecordsOfADOfDealsRsp rsp = FetchRecordsOfADOfDealsRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        // print('data map: ${rsp.getDataMap().toString()}');
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
      print("Deals.fetchRecordsOfADOfDealsHandler failure, $e");
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
    Runtime.setObserve(observe);
    // fetchVersionOfADOfDeals();
    fetchIdListOfADOfDeals();
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("Deals.observe: major: $major, minor: $minor");
      if (major == Major.advertisement && minor == Minor.advertisement.fetchVersionOfADOfDealsRsp) {
        fetchVersionOfADOfDealsHandler(body);
      } else if (major == Major.advertisement && minor == Minor.advertisement.fetchRecordsOfADOfDealsRsp) {
        fetchRecordsOfADOfDealsHandler(body);
      } else if (major == Major.advertisement && minor == Minor.advertisement.fetchIdListOfADOfDealsRsp) {
        fetchIdListOfADOfDealsHandler(body);
      } else if (major == Major.admin && minor == Minor.admin.insertRecordOfADOfDealsRsp) {
        insertRecordOfADOfDealsHandler(body);
      } else {
        print("Deals.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Deals.observe($major-$minor).e: ${e.toString()}');
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
                        width: 250,
                        child: Text(
                          Translator.translate(Language.menuOfDeals),
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacing.addHorizontalSpace(20),
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
                          icon: const Icon(Icons.refresh),
                          onPressed: () async {
                            resetSource();
                            curStage++;
                            fetchIdListOfADOfDeals();
                          },
                          label: Text(
                            Translator.translate(Language.titleOfRefreshOperation),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            showApproveAdvertisementOfADOfDealsDialog(context).then(
                              (value) => () {
                                if (value > 0) {
                                  if (!idList.contains(value)) {
                                    idList.add(value);
                                    curStage++;
                                  }
                                }
                              }(),
                            );
                          },
                          label: Text(
                            Translator.translate(Language.approveAdvertisementToGroup),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.publish),
                          onPressed: () async {
                            if (idList.isEmpty) {
                              showMessageDialog(
                                context,
                                Translator.translate(Language.titleOfNotification),
                                Translator.translate(Language.advertisementOfADOfDealsNotProvided),
                              );
                              return;
                            }
                            insertRecordOfADOfDeals(
                              advertisementIdList: idList,
                            );
                          },
                          label: Text(
                            Translator.translate(Language.titleOfPublishOfAdvertisement),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                      source: Source(context, idList, dataMap, datetimeMap, boolMap),
                      header: Text(Translator.translate(Language.listOfAdvertisements)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.idOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.idOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfGood))),
                        DataColumn(label: Text(Translator.translate(Language.titleOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.sellingPriceOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.placeOfOriginOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.sellingPointsOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.stockOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.thumbnailOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.imageOfAdvertisement))),
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
  Map<int, ADOfDeals> dataMap;
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
    var advertisementId = Translator.translate(Language.loading);
    var advertisementName = Translator.translate(Language.loading);
    var productId = Translator.translate(Language.loading);
    var productName = Translator.translate(Language.loading);
    var titleOfAdvertisement = Translator.translate(Language.loading);
    var sellingPrice = Translator.translate(Language.loading);
    var placeOfOrigin = Translator.translate(Language.loading);
    var stockOfAdvertisement = Translator.translate(Language.loading);
    List<String> sellingPoints = [];

    var key = idList[index];

    if (boolMap.containsKey(key)) {
      // fetch row finished
      if (dataMap.containsKey(key)) {
        advertisementId = dataMap[key]!.getAdvertisementId().toString();
        advertisementName = dataMap[key]!.getAdvertisementName();
        productId = dataMap[key]!.getProductId().toString();
        productName = dataMap[key]!.getProductName();
        titleOfAdvertisement = dataMap[key]!.getTitle();
        sellingPrice = dataMap[key]!.getSellingPrice().toString();
        placeOfOrigin = dataMap[key]!.getPlaceOfOrigin();
        stockOfAdvertisement = dataMap[key]!.getStock().toString();
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
        fetchRecordsOfADOfDeals(advertisementIdList: requestIdList);
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
        DataCell(Text(advertisementId)),
        DataCell(Text(advertisementName)),
        DataCell(Text(productId)),
        DataCell(Text(productName)),
        DataCell(Text(titleOfAdvertisement)),
        DataCell(Text(sellingPrice)),
        DataCell(Text(placeOfOrigin)),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              showSellingPointOfAdvertisementDialog(buildContext, advertisementId, sellingPoints);
            },
          ),
        ),
        DataCell(Text(stockOfAdvertisement)),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.search),
            onPressed: () {
              // show image
            },
          ),
        ),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.search),
            onPressed: () {
              // show image
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                tooltip: Translator.translate(Language.rejectAdvertisementFromGroup),
                onPressed: () async {
                  await showRejectAdvertisementOfADOfDealsDialog(buildContext, advertisementId, advertisementName).then(
                    (value) => () {
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
