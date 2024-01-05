import 'package:flutter/material.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import '../config/config.dart';

Future<bool> showViewNetworkImageGroupDialog(BuildContext context, List<String> urls) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;
  String from = 'showViewNetworkImageGroupDialog';
  int currentImage = 0;

  print('showViewNetworkImageGroupDialog.urls: $urls');

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
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

  Function? back() {
    if (currentImage <= 0) {
      return null;
    } else if (currentImage - 1 >= 0) {
      currentImage = currentImage - 1;
      curStage++;
    }
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              if (currentImage -1 >= 0) {
                currentImage = currentImage -1;
                curStage++;
              }
            },
            child: Text(Translator.translate(Language.back)),
          ),
          TextButton(
            onPressed: () {
              if (currentImage + 1 <= urls.length -1) {
                currentImage = currentImage + 1;
                curStage++;
              }
            },
            child: Text(Translator.translate(Language.next)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.confirm)),
          ),
        ],
        content: StreamBuilder(
          builder: (context, snap) {
            return SizedBox(
              width: 500,
              height: 500,
              child: SingleChildScrollView(
                  child: Center(
                child: Column(
                  children: [
                    if (urls.isNotEmpty)
                      Center(child: Text('${currentImage+1}/${urls.length}')),
                    if (urls.isNotEmpty)
                      Center(
                        child: SizedBox(
                          width: 500,
                          height: 500,
                          child: Image.network(urls[currentImage]),
                        ),
                      ),
                  ],
                ),
              )),
            );
          },
          stream: stream(),
        ),
      );
    },
  ).then((value) {
    closed = true;
    Runtime.setObserve(oriObserve);
    return curStage > 0;
  });
}
