import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_ad_of_deals/insert_record_of_ad_of_deals_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_ad_of_deals/insert_record_of_ad_of_deals_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_ad_of_deals.dart';
import 'package:flutter_framework/common/service/advertisement/business/fetch_id_list_of_ad_of_deals.dart';
import 'package:flutter_framework/common/service/advertisement/business/fetch_records_of_ad_of_deals.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/advertisement.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_id_list_of_ad_of_deals.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_records_of_ad_of_deals.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/fetch_version_of_ad_of_deals.dart';
import 'dart:async';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/common/service/admin/dialog/approve_advertisement.dart';
import 'package:flutter_framework/common/service/admin/dialog/reject_advertisement.dart';
import 'package:flutter_framework/common/service/advertisement/dialog/selling_point_of_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/view_network_image.dart';
import 'package:flutter_framework/dashboard/dialog/view_network_image_group.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/ad_of_deals.dart';
import 'package:flutter_framework/dashboard/theme.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/local/image_item.dart';

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
  InsertRecordOfADOfDealsProgress? insertRecordOfADOfDealsProgress;

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

  void insertRecordOfADOfDealsHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'insertRecordOfADOfDealsHandler';
    try {
      var rsp = InsertRecordOfADOfDealsRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (insertRecordOfADOfDealsProgress != null) {
        insertRecordOfADOfDealsProgress!.respond(rsp);
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'failure, err: $e',
      );
    } finally {}
  }

  void fetchVersionOfADOfDealsHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchVersionOfADOfDealsHandler';
    try {
      var rsp = FetchVersionOfADOfDealsRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'failure, err: $e',
      );
    } finally {}
  }

  void fetchIdListOfADOfDealsHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchIdListOfADOfDealsHandler';
    try {
      var rsp = FetchIdListOfADOfDealsRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Log.debug(
          major: major,
          minor: minor,
          from: Deals.content,
          caller: caller,
          message: 'advertisement id list: ${rsp.getIdList()}',
        );
        if (rsp.getIdList().isEmpty) {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.noRecordsPublished),
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
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void fetchRecordsOfADOfDealsHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRecordsOfADOfDealsHandler';
    try {
      var rsp = FetchRecordsOfADOfDealsRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        // print('data map: ${rsp.getDataMap().toString()}');

        List<int> tempIdList = [];
        if (rsp.getDataMap().isNotEmpty) {
          rsp.getDataMap().forEach((key, value) {
            tempIdList.add(value.getAdvertisementId());
          });
        }
        Log.debug(
          major: major,
          minor: minor,
          from: Deals.content,
          caller: caller,
          message: 'advertisement id list: $tempIdList',
        );

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
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'failure, err: $e',
      );
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
    var caller = 'setup';
    Runtime.setObserve(observe);
    // fetchVersionOfADOfDeals();
    fetchIdListOfADOfDeals(
      from: Deals.content,
      caller: caller,
    );
  }

  void observe(PacketClient packet) {
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var routingKey = '$major-$minor';
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.advertisement && minor == Advertisement.fetchVersionOfADOfDealsRsp) {
        fetchVersionOfADOfDealsHandler(major: major, minor: minor, body: body);
      } else if (major == Major.advertisement && minor == Advertisement.fetchRecordsOfADOfDealsRsp) {
        fetchRecordsOfADOfDealsHandler(major: major, minor: minor, body: body);
      } else if (major == Major.advertisement && minor == Advertisement.fetchIdListOfADOfDealsRsp) {
        fetchIdListOfADOfDealsHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.insertRecordOfADOfDealsRsp) {
        insertRecordOfADOfDealsHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Deals.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Deals.content,
        caller: caller,
        message: 'failure, err: $e',
      );
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
    var caller = 'build';
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
                      onPageChanged: (int? n) {
                        curStage++;
                      },
                      actions: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: THEME.backgroundColorOfButton,
                          ),
                          icon: const Icon(Icons.refresh),
                          onPressed: () async {
                            resetSource();
                            curStage++;
                            fetchIdListOfADOfDeals(
                              from: Deals.content,
                              caller: '$caller.fetchIdListOfADOfDeals',
                            );
                          },
                          label: Text(
                            Translator.translate(Language.titleOfRefreshOperation),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: THEME.backgroundColorOfButton,
                          ),
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            showApproveAdvertisementDialog(context).then(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: THEME.backgroundColorOfButton,
                          ),
                          icon: const Icon(Icons.publish),
                          onPressed: () async {
                            if (idList.isEmpty) {
                              showMessageDialog(
                                context,
                                Translator.translate(Language.titleOfNotification),
                                Translator.translate(Language.noAdvertisementAssociated),
                              );
                              return;
                            }
                            if (insertRecordOfADOfDealsProgress == null) {
                              var step = InsertRecordOfADOfDealsStep.construct(
                                advertisementIdList: idList,
                              );
                              insertRecordOfADOfDealsProgress = InsertRecordOfADOfDealsProgress.construct(
                                step: step,
                              );
                              insertRecordOfADOfDealsProgress!.show(context: context).then((value) {
                                if (value != Code.oK) {
                                  showMessageDialog(
                                    context,
                                    Translator.translate(Language.titleOfNotification),
                                    '${Translator.translate(Language.failureWithErrorCode)}  ${step.getCode()}',
                                  );
                                } else {
                                  // success
                                  showMessageDialog(
                                    context,
                                    Translator.translate(Language.titleOfNotification),
                                    Translator.translate(Language.publishAdvertisementsSuccessfully),
                                  );
                                }
                                insertRecordOfADOfDealsProgress = null;
                              });
                            }
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
                        DataColumn(label: Text(Translator.translate(Language.idOfProduct))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfProduct))),
                        DataColumn(label: Text(Translator.translate(Language.titleOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.sellingPriceOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.placeOfOriginOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.sellingPointsOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.stockOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.statusOfAdvertisement))),
                        DataColumn(label: Text(Translator.translate(Language.coverImageOfAdvertisement))),
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
        // print("length: ${idList.length}");
        return idList.length;
      }();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    var caller = 'Source.getRow';
    // print("getRow: $index");
    var advertisementId = Translator.translate(Language.loading);
    var advertisementName = Translator.translate(Language.loading);
    var productId = Translator.translate(Language.loading);
    var productName = Translator.translate(Language.loading);
    var titleOfAdvertisement = Translator.translate(Language.loading);
    var sellingPrice = Translator.translate(Language.loading);
    var placeOfOrigin = Translator.translate(Language.loading);
    var stockOfAdvertisement = Translator.translate(Language.loading);
    // var statusOfAdvertisement = Translator.translate(Language.loading);
    Text status = Text(Translator.translate(Language.loading));
    List<String> sellingPoints = [];
    // Map<String, ImageItem> imageMap = {};

    var key = idList[index];

    if (boolMap.containsKey(key)) {
      // fetch row finished
      if (dataMap.containsKey(key)) {
        advertisementId = dataMap[key]!.getAdvertisementId().toString();
        advertisementName = dataMap[key]!.getAdvertisementName();
        productId = dataMap[key]!.getProductId().toString();
        productName = dataMap[key]!.getProductName();
        titleOfAdvertisement = dataMap[key]!.getTitle();
        placeOfOrigin = dataMap[key]!.getPlaceOfOrigin();
        stockOfAdvertisement = dataMap[key]!.getStock().toString();
        status = dataMap[key]!.getStatus() == 1
            ? Text(
                Translator.translate(Language.enable),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              )
            : Text(Translator.translate(Language.disable),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ));
        sellingPoints = dataMap[key]!.getSellingPoints();
        sellingPrice = Convert.intDivide10toDoubleString(dataMap[key]!.getSellingPrice());
      } else {
        print("unknown error: dataMap.containsKey(key) == false");
      }
    } else {
      if (datetimeMap.containsKey(key)) {
        // item requested
        datetimeMap.remove(key);
      } else {
        // item not requested
        List<int> requestIdList = [];
        requestIdList.add(key);
        datetimeMap[key] = DateTime.now();
        if (index % 5 == 0 || index == 0) {
          for (var i = index + 1; i < index + 5; i++) {
            if (i >= idList.length) {
              break;
            }
            requestIdList.add(idList[i]);
            datetimeMap[idList[i]] = DateTime.now();
          }
        }
        // print("requestIdList: $requestIdList");
        fetchRecordsOfADOfDeals(
          from: Deals.content,
          caller: '$caller.fetchRecordsOfADOfDeals',
          advertisementIdList: requestIdList,
        );
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
        DataCell(status),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.search),
            onPressed: () {
              // show cover image
              // print('view cover image');
              var coverImageUrl = ImageItem.getImageUrl(dataMap[key]!.getCoverImage(), dataMap[key]!.getOSSPath());
              var ret = Uri.parse(coverImageUrl).isAbsolute;
              if (!ret) {
                showWarningDialog(buildContext, Translator.translate(Language.urlIllegal));
                return;
              }
              showViewNetworkImageDialog(buildContext, coverImageUrl);
            },
          ),
        ),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.search),
            onPressed: () {
              // show image
              // print('view image');
              showViewNetworkImageGroupDialog(
                buildContext,
                ImageItem.getImageUrlList(
                  first: dataMap[key]!.getFirstImage(),
                  second: dataMap[key]!.getSecondImage(),
                  third: dataMap[key]!.getThirdImage(),
                  fourth: dataMap[key]!.getFourthImage(),
                  fifth: dataMap[key]!.getFifthImage(),
                  ossPath: dataMap[key]!.getOSSPath(),
                ),
              );
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
                  await showRejectAdvertisementDialog(buildContext, advertisementId, advertisementName).then(
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
