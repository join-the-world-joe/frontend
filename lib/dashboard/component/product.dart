import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_product/insert_record_of_product_progress.dart';
import 'package:flutter_framework/common/service/product/protocol/fetch_records_of_product.dart';
import 'package:flutter_framework/common/service/product/business/fetch_id_list_of_product.dart';
import 'package:flutter_framework/common/service/product/business/fetch_records_of_product.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'dart:async';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/common/service/admin/dialog/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/dialog/soft_delete_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/dialog/update_record_of_product.dart';
import 'package:flutter_framework/dashboard/model/user_list.dart';
import 'package:flutter_framework/dashboard/theme.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import '../model/product.dart' as model;
import 'package:flutter_framework/common/service/product/protocol/fetch_id_list_of_product.dart';
import 'package:flutter_framework/common/route/product.dart' as route;

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  static String content = 'Product';

  @override
  State createState() => _State();
}

class _State extends State<Product> {
  bool closed = false;
  int curStage = 1;
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final vendorController = TextEditingController();
  final scrollController = ScrollController();
  List<int> idList = [];
  Map<int, model.Product> dataMap = {};
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
          print('Product.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void fetchIdListOfProductHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchIdListOfProductHandler';
    try {
      var rsp = FetchIdListOfProductRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        Log.debug(
          major: major,
          minor: minor,
          from: Product.content,
          caller: caller,
          message: 'product id list: ${rsp.getIdList()}',
        );
        if (rsp.getIdList().isEmpty) {
          if (rsp.getBehavior() == 1) {
            showMessageDialog(
              context,
              Translator.translate(Language.titleOfNotification),
              Translator.translate(Language.noRecordOfProductInDatabase),
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
        from: Product.content,
        caller: caller,
        message: 'failure, err: $e',
      );

      return;
    }
  }

  void fetchRecordsOfProductHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRecordsOfProductHandler';
    try {
      var rsp = FetchRecordsOfProductRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        // print('product map: ${rsp.getDataMap().toString()}');
        if (Config.debug) {
          List<int> tempList = [];
          rsp.getDataMap().forEach((key, value) {
            tempList.add(value.getId());
          });
          Log.debug(
            major: major,
            minor: minor,
            from: Product.content,
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
        from: Product.content,
        caller: caller,
        message: 'failure, err: $e',
      );
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
    var caller = 'observe';

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Product.content,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.product && minor == route.Product.fetchIdListOfProductRsp) {
        fetchIdListOfProductHandler(major: major, minor: minor, body: body);
      } else if (major == Major.product && minor == route.Product.fetchRecordsOfProductRsp) {
        fetchRecordsOfProductHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Product.content,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Product.content,
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
                        width: 110,
                        child: TextFormField(
                          controller: idController,
                          decoration: InputDecoration(
                            // border: const UnderlineInputBorder(),
                            labelText: Translator.translate(Language.idOfProduct),
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
                            labelText: Translator.translate(Language.nameOfProduct),
                          ),
                        ),
                      ),
                      Spacing.addHorizontalSpace(20),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: THEME.backgroundColorOfButton,
                          ),
                          onPressed: () {
                            if (idController.text.isEmpty && nameController.text.isEmpty) {
                              resetSource();
                              fetchIdListOfProduct(
                                from: Product.content,
                                caller: '${caller}.fetchIdListOfProduct',
                                behavior: 1,
                                productName: "",
                                categoryId: 0,
                              );
                              return;
                            }
                            if (idController.text.isNotEmpty) {
                              resetSource();
                              fetchRecordsOfProduct(
                                from: Product.content,
                                caller: '${caller}fetchRecordsOfProduct',
                                productIdList: [int.parse(idController.text)],
                              );
                              return;
                            }
                            if (nameController.text.isNotEmpty) {
                              resetSource();
                              fetchIdListOfProduct(
                                from: Product.content,
                                caller: '${caller}fetchIdListOfProduct',
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: THEME.backgroundColorOfButton,
                          ),
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
                      onPageChanged: (int? n) {
                        curStage++;
                      },
                      actions: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: THEME.backgroundColorOfButton,
                          ),
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            showInsertRecordOfProductDialog(context);
                          },
                          label: Text(
                            Translator.translate(Language.importProduct),
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                      source: Source(context, idList, dataMap, datetimeMap, boolMap),
                      header: Text(Translator.translate(Language.listOfProducts)),
                      columns: [
                        DataColumn(label: Text(Translator.translate(Language.idOfProduct))),
                        DataColumn(label: Text(Translator.translate(Language.nameOfProduct))),
                        DataColumn(label: Text(Translator.translate(Language.buyingPrice))),
                        DataColumn(label: Text(Translator.translate(Language.vendorOfProduct))),
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
  Map<int, model.Product> dataMap;
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
    var caller = 'getRow';
    // print("getRow: $index");
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
        vendor = dataMap[key]!.getVendor();
        contact = dataMap[key]!.getContact();
        buyingPrice = Convert.intDivide10toDoubleString(dataMap[key]!.getBuyingPrice());
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
        fetchRecordsOfProduct(
          from: Product.content,
          caller: '$caller.fetchRecordsOfProduct',
          productIdList: requestIdList,
        );
      }
    }

    return DataRow(
      selected: false,
      onSelectChanged: (selected) {
        // print('selected: $selected');
        // notifyListeners();
      },
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(buyingPrice)),
        DataCell(Text(vendor)),
        DataCell(Text(contact)),
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
                  showUpdateRecordOfProductDialog(buildContext, dataMap[key]!).then((value) {
                    if (value) {
                      print("notifyListeners");
                      fetchRecordsOfProduct(
                        from: Product.content,
                        caller: caller,
                        productIdList: [dataMap[key]!.getId()],
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
                  if (!boolMap.containsKey(key)) {
                    return;
                  }
                  await showSoftDeleteRecordsOfProductDialog(buildContext, dataMap[key]!).then(
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
