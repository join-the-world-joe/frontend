import 'dart:js_interop';
import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/fetch_track_list_of_condition.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/model/track_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
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

class Track extends StatefulWidget {
  const Track({Key? key}) : super(key: key);

  static String content = 'Track';

  @override
  State createState() => _State();
}

class _State extends State<Track> {
  bool closed = false;
  int curStage = 1;
  final scrollController = ScrollController();
  TextEditingController majorController = TextEditingController();
  TextEditingController minorController = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  TextEditingController beginController = TextEditingController(text: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');
  TextEditingController endController = TextEditingController(text: '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}');

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
          print('Track.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void setup() {
    print('Track.setup');
    Cache.setTrackList(TrackList([]));
    Runtime.setObserve(observe);
  }

  void fetchTrackListOfConditionHandler(Map<String, dynamic> body) {
    try {
      FetchTrackListOfConditionRsp rsp = FetchTrackListOfConditionRsp.fromJson(body);
      print('rsp: ${body.toString()}');
      if (rsp.code == Code.oK) {
        print('rsp: ${rsp.toString()}');
        Cache.setTrackList(TrackList.fromJson(rsp.body));
        curStage++;
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("Track.fetchTrackListOfConditionHandler failure, $e");
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      // print("User.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.fetchTrackListOfConditionRsp) {
        fetchTrackListOfConditionHandler(body);
      } else {
        print("Track.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Track.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void refresh() {
    // print('User.refresh');
    setState(() {});
  }

  @override
  void dispose() {
    print('Track.dispose');
    closed = true;
    super.dispose();
  }

  @override
  void initState() {
    print('Track.initState');
    setup();
    super.initState();
  }

  Future<String?> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      var year = picked.year;
      var month = picked.month;
      var day = picked.day.toString().length == 2 ? picked.day.toString() : '0${picked.day}';
      return '$year-$month-$day';
    } else {
      return null;
    }
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
                      width: 70,
                      child: TextFormField(
                        controller: operatorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.titleOfOperator),
                        ),
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: majorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.major),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(3),
                        ],
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        controller: minorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.minor),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(3),
                        ],
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        readOnly: true,
                        controller: beginController,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          labelText: Translator.translate(Language.titleOfBeginDate),
                        ),
                        onTap: () async {
                          var any = await selectDate();
                          if (any != null) {
                            beginController.text = any;
                          }
                          refresh();
                        },
                      ),
                    ),
                    Spacing.addHorizontalSpace(20),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        readOnly: true,
                        controller: endController,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: const Icon(Icons.calendar_month_outlined),
                          labelText: Translator.translate(Language.titleOfEndDate),
                        ),
                        onTap: () async {
                          var any = await selectDate();
                          if (any != null) {
                            endController.text = any;
                          }
                          refresh();
                        },
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
                            minor: int.parse(Minor.admin.fetchTrackListOfConditionReq),
                          )) {
                            return;
                          }

                          // print('begin string: ${beginController.text}');
                          // print('end string: ${endController.text}');
                          var begin = DateTime.parse(beginController.text);
                          var end = DateTime.parse(endController.text).add(const Duration(days: 0, hours: 23, minutes: 59, seconds: 59, milliseconds: 999));
                          if (end.isBefore(begin)) {
                            showMessageDialog(context, Translator.translate(Language.titleOfNotification), Translator.translate(Language.endDateIsBeforeBeginDate));
                            return;
                          }
                          var d1 = DateTime.parse(beginController.text).millisecondsSinceEpoch;
                          var d2 = DateTime.parse(endController.text).add(const Duration(days: 0, hours: 23, minutes: 59, seconds: 59, milliseconds: 999)).millisecondsSinceEpoch;
                          // print('begin int: ${d1 ~/ 1000}');
                          // print('end int: ${d2 ~/ 1000}');
                          fetchTrackListOfCondition(
                            operator: operatorController.text,
                            behavior: 2,
                            begin: d1 ~/ 1000,
                            end: d2 ~/ 1000,
                            major: majorController.text,
                            minor: minorController.text,
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
                          Cache.setTrackList(TrackList([]));
                          operatorController.text = '';
                          majorController.text = '';
                          minorController.text = '';
                          beginController.text = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
                          endController.text = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
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
                Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: PaginatedDataTable(
                    controller: scrollController,
                    source: Source(context),
                    header: Text(Translator.translate(Language.operationLog)),
                    columns: [
                      DataColumn(label: Text(Translator.translate(Language.titleOfOperator))),
                      DataColumn(label: Text(Translator.translate(Language.titleOfPermission))),
                      DataColumn(label: Text(Translator.translate(Language.major))),
                      DataColumn(label: Text(Translator.translate(Language.minor))),
                      DataColumn(label: Text(Translator.translate(Language.request))),
                      DataColumn(label: Text(Translator.translate(Language.response))),
                      DataColumn(label: Text(Translator.translate(Language.operationTimestamp))),
                    ],
                    columnSpacing: 60,
                    horizontalMargin: 10,
                    rowsPerPage: 5,
                    showCheckboxColumn: false,
                  ),
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
  TrackList trackList = Cache.getTrackList();

  Source(this.context);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => trackList.getLength();

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    // print("getRow: $index");
    return DataRow(
      selected: false,
      onSelectChanged: (selected) {},
      cells: [
        DataCell(Text(trackList.getBody()[index].getOperator())),
        DataCell(Text(Translator.translate(trackList.getBody()[index].getPermission()))),
        DataCell(Text(trackList.getBody()[index].getMajor())),
        DataCell(Text(trackList.getBody()[index].getMinor())),
        DataCell(
          IconButton(
            tooltip: trackList.getBody()[index].getRequest(),
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              //   showRoleListOfUserDialog(context, _data[index]);
              Clipboard.setData(ClipboardData(text: trackList.getBody()[index].getRequest()));
            },
          ),
        ),
        DataCell(
          IconButton(
            tooltip: trackList.getBody()[index].getResponse(),
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              //   showRoleListOfUserDialog(context, _data[index]);
              Clipboard.setData(ClipboardData(text: trackList.getBody()[index].getResponse()));
            },
          ),
        ),
        DataCell(Text(trackList.getBody()[index].getTimestamp().toString())),
        // DataCell(Text(trackList.getBody()[index].getRequest())),
        // DataCell(Text(trackList.getBody()[index].getResponse())),
      ],
    );
  }
}
