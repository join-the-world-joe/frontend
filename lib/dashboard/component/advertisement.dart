import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/dashboard/dialog/edit_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/remove_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/selling_point_of_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/update_advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/view_network_image.dart';
import 'package:flutter_framework/dashboard/dialog/view_network_image_group.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/user_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../model/advertisement.dart' as model;
import 'package:flutter_framework/common/protocol/admin/fetch_id_list_of_advertisement.dart';
import 'package:flutter_framework/common/business/admin/fetch_id_list_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_advertisement.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_advertisement.dart';

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
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Advertisement.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.fetchIdListOfAdvertisementRsp) {
        fetchIdListOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.fetchRecordsOfAdvertisementRsp) {
        fetchRecordsOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Advertisement.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Advertisement.content,
        caller: caller,
        message: 'failure, err: $e',
      );
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

  void fetchIdListOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchIdListOfAdvertisementHandler';
    try {
      FetchIdListOfAdvertisementRsp rsp = FetchIdListOfAdvertisementRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        Log.debug(
          major: major,
          minor: minor,
          from: Advertisement.content,
          caller: caller,
          message: 'advertisement id list: ${rsp.getIdList()}',
        );
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
      Log.debug(
        major: major,
        minor: minor,
        from: Advertisement.content,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void fetchRecordsOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRecordsOfAdvertisementHandler';
    try {
      FetchRecordsOfAdvertisementRsp rsp = FetchRecordsOfAdvertisementRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        if (Config.debug) {
          List<int> tempList = [];
          rsp.getDataMap().forEach((key, value) {
            tempList.add(value.getId());
          });
          Log.debug(
            major: major,
            minor: minor,
            from: Advertisement.content,
            caller: caller,
            message: 'id list: $tempList',
          );
        }
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
        from: Advertisement.content,
        caller: caller,
        message: 'failure, err: $e',
      );
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
                              resetSource();
                              fetchIdListOfAdvertisement(
                                from: Advertisement.content,
                                caller: '$caller.fetchIdListOfAdvertisement',
                                behavior: 1,
                                advertisementName: "",
                              );
                              return;
                            }
                            if (idController.text.isNotEmpty) {
                              resetSource();
                              fetchRecordsOfAdvertisement(
                                from: Advertisement.content,
                                caller: '$caller.fetchRecordsOfAdvertisement',
                                advertisementIdList: [int.parse(idController.text)],
                              );
                              return;
                            }
                            if (nameController.text.isNotEmpty) {
                              resetSource();
                              fetchIdListOfAdvertisement(
                                from: Advertisement.content,
                                caller: '$caller.fetchIdListOfAdvertisement',
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
                      onPageChanged: (int? n) {
                        print('onPageChanged: $n');
                        curStage++;
                      },
                      actions: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            showEditAdvertisementDialog(context);
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
                        DataColumn(label: Text(Translator.translate(Language.statusOfAdvertisement))),
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
        // print("length: ${idList.length}");
        return idList.length;
      }();

  @override
  int get selectedRowCount => 0;

  String getThumbnail(String image) {
    String output = '';
    try {
      Map<String, dynamic> temp = jsonDecode(image);
      if (temp.containsKey('0')) {
        output =  temp['0'];
      }
    } catch(e) {
      print('Advertisement.Source.getThumbnail failure, err: $e');
    }
    return output;
  }

  List<String> getImageUrlList(String image) {
    List<String> output = [];
    try {
      Map<String, dynamic> temp = jsonDecode(image);
      temp.forEach((key, value) {
        if (key != '0') {
          output.add(value);
        }
      });
    } catch(e) {
      print('Advertisement.Source.getImageUrlList failure, err: $e');
    }
    return output;
  }

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    var caller = 'Source.getRow';
    var idOfAdvertisement = Translator.translate(Language.loading);
    var idOfGood = Translator.translate(Language.loading);
    var nameOfAdvertisement = Translator.translate(Language.loading);
    var titleOfAdvertisement = Translator.translate(Language.loading);
    var sellingPriceOfAdvertisement = Translator.translate(Language.loading);
    var placeOfOrigin = Translator.translate(Language.loading);
    List<String> sellingPoints = [];
    var stock = Translator.translate(Language.loading);
    Text status = Text(Translator.translate(Language.loading));
    var image = Translator.translate(Language.loading);
    var key = idList[index];
    var thumbnailUrl = '';
    List<String> imageUrlList = [];

    if (boolMap.containsKey(key)) {
      // fetch row finished
      if (dataMap.containsKey(key)) {
        idOfAdvertisement = dataMap[key]!.getId().toString();
        nameOfAdvertisement = dataMap[key]!.getName();
        titleOfAdvertisement = dataMap[key]!.getTitle();
        placeOfOrigin = dataMap[key]!.getPlaceOfOrigin();
        stock = dataMap[key]!.getStock().toString();
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
        idOfGood = dataMap[key]!.getProductId().toString();
        image = dataMap[key]!.getImage().toString();
        sellingPoints = dataMap[key]!.getSellingPoints();
        sellingPriceOfAdvertisement = Convert.intDivide10toDoubleString(dataMap[key]!.getSellingPrice());
        if (image.isNotEmpty) {
          thumbnailUrl = getThumbnail(image);
          imageUrlList = getImageUrlList(image);
        }
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
        print("requestIdList: $requestIdList");
        fetchRecordsOfAdvertisement(
          from: Advertisement.content,
          caller: '$caller.fetchRecordsOfAdvertisement',
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
              if (idOfAdvertisement.compareTo(Translator.translate(Language.loading)) == 0) {
                return;
              }
              showSellingPointOfAdvertisementDialog(buildContext, idOfAdvertisement, sellingPoints);
            },
          ),
        ),
        DataCell(Text(stock)),
        DataCell(status),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.search),
            onPressed: () {
              // show thumbnail
              print('view thumbnail');
              var ret = Uri.parse(thumbnailUrl).isAbsolute;
              if (!ret) {
                showWarningDialog(buildContext, Translator.translate(Language.urlIllegal));
                print('url: $thumbnailUrl, image: $image');
                return;
              }
              showViewNetworkImageDialog(buildContext, thumbnailUrl);
            },
          ),
        ),
        DataCell(
          IconButton(
            tooltip: Translator.translate(Language.clickToView),
            icon: const Icon(Icons.search),
            onPressed: () {
              // show image
              print('view image');
              showViewNetworkImageGroupDialog(buildContext, imageUrlList);
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: Translator.translate(Language.update),
                onPressed: () async {
                  if (!boolMap.containsKey(key)) {
                    return;
                  }
                  showUpdateAdvertisementDialog(buildContext, dataMap[key]!).then((value) {
                    if (value) {
                      fetchRecordsOfAdvertisement(
                        from: Advertisement.content,
                        caller: '$caller.fetchRecordsOfAdvertisement',
                        advertisementIdList: [dataMap[key]!.getId()],
                      );
                      notifyListeners();
                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: Translator.translate(Language.remove),
                onPressed: () async {
                  await showRemoveAdvertisementDialog(buildContext, dataMap[key]!.getId(), dataMap[key]!.getName()).then(
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
