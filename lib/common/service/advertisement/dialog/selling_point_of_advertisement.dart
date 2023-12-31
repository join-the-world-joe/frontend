import 'package:flutter/material.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../../../../dashboard/config/config.dart';

Future<String> showSellingPointOfAdvertisementDialog(BuildContext context, String id, List<String> sellingPoints) async {
  bool closed = false;
  int curStage = 0;
  String from = 'showSellingPointOfAdvertisementDialog';

  var oriObserve = Runtime.getObserve();
  var sellingPointController = TextEditingController();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showSellingPointOfAdvertisementDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void observe(PacketClient packet) {
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'responded',
      );
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'not matched',
      );
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('${Translator.translate(Language.idOfAdvertisement)}: $id'),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.pop(context, ""),
          //   child: Text(Translator.translate(Language.cancel)),
          // ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, "");
              return;
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          // Spacing.AddVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            return SizedBox(
              width: 450,
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: sellingPointController,
                        decoration: InputDecoration(
                          prefixIcon: Wrap(
                            children: () {
                              List<Widget> widgetList = [];
                              for (var element in sellingPoints) {
                                // print('element: ${element}');
                                widgetList.add(Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InputChip(
                                    label: Text(
                                      element,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.green,
                                    selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                ));
                              }
                              return widgetList;
                            }(),
                          ),
                          // labelText: Translator.translate(Language.sellingPointsOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).then(
    (value) {
      closed = true;
      Runtime.setObserve(oriObserve);
      return sellingPointController.text;
    },
  );
}
