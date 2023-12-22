import 'dart:convert';
import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/dashboard/dialog/view_image.dart';
import 'package:flutter_framework/dashboard/dialog/view_network_image.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../model/advertisement.dart';
import 'package:flutter_framework/dashboard/dialog/fill_selling_point.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/business/admin/update_record_of_advertisement.dart';
import 'package:path/path.dart' as path;

/*
use cases
1. delete image; modify original record
2. add new image; need to upload image
3. delete image & add new image; modify record & need to upload image

optimization
1. frontend provides the remove key list for backend
2. frontend use the update interface to modify the specific record
 */

class ImageItem {
  bool _native = false;
  String _nativeFileName = ''; // for native file
  Uint8List _data = Uint8List(0); // for native file
  String _objectFile = ''; // oss object file name
  String _url = ''; // uploaded; oss url
  String _key = ''; // key of image in database

  bool getNative() {
    return _native;
  }

  String getKey() {
    return _key;
  }

  String getUrl() {
    return _url;
  }

  String getObjectFile() {
    return _objectFile;
  }

  Uint8List getData() {
    return _data;
  }

  String getNativeFileName() {
    return _nativeFileName;
  }

  ImageItem.construct({
    required bool native,
    required Uint8List data,
    required String objectFile,
    required String url,
    required String nativeFileName,
    required String key,
  }) {
    _key = key;
    _native = native;
    _data = data;
    _objectFile = objectFile;
    _url = url;
    _nativeFileName = nativeFileName;
  }
}

Future<bool> showUpdateAdvertisementDialog(BuildContext context, Advertisement advertisement) async {
  int status = advertisement.getStatus();
  int curStage = 0;
  bool closed = false;
  String from = 'showUpdateAdvertisementDialog';
  List<String> sellingPoints = advertisement.getSellingPoints();
  var oriObserve = Runtime.getObserve();
  var nameController = TextEditingController(text: advertisement.getName());
  var titleController = TextEditingController(text: advertisement.getTitle());
  var sellingPriceController = TextEditingController(text: Convert.intDivide10toDoubleString(advertisement.getSellingPrice()));
  var placeOfOriginController = TextEditingController(text: advertisement.getPlaceOfOrigin());
  var imageController = TextEditingController(text: '');
  var thumbnailController = TextEditingController(text: '');
  var stockController = TextEditingController(text: advertisement.getStock().toString());
  var productIdController = TextEditingController(text: advertisement.getProductId().toString());
  var sellingPointController = TextEditingController();
  Map<String, ImageItem> imageMap = {};

  try {
    Map<String, dynamic> image = jsonDecode(advertisement.getImage());
    image.forEach((key, value) {
      imageMap[key] = ImageItem.construct(
        native: false,
        data: Uint8List(0),
        objectFile: '',
        url: value,
        nativeFileName: '',
        key: key,
      );
    });
  } catch (e) {
    print('showUpdateAdvertisementDialog failure, err: $e');
  }

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void updateRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'updateRecordOfAdvertisementHandler';
    try {
      UpdateRecordOfAdvertisementRsp rsp = UpdateRecordOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: '${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.updateRecordSuccessfully),
        ).then(
          (value) {
            Navigator.pop(context, true);
          },
        );
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
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    } finally {}
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
        from: from,
        caller: caller,
        message: '',
      );
      if (major == Major.admin && minor == Admin.updateRecordOfAdvertisementRsp) {
        updateRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: from,
          caller: caller,
          message: 'not matched',
        );
      }
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
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        title: Text(Translator.translate(Language.modifyAdvertisement)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              // print('advertisement.getId: ${advertisement.getId()}');
              updateRecordOfAdvertisement(
                from: from,
                caller: '$caller.updateRecordOfAdvertisement',
                id: advertisement.getId(),
                image: imageController.text,
                name: nameController.text,
                stock: int.parse(stockController.text),
                status: status,
                title: titleController.text,
                productId: int.parse(productIdController.text),
                sellingPrice: Convert.doubleStringMultiple10toInt(sellingPriceController.text),
                placeOfOrigin: placeOfOriginController.text,
                sellingPoints: sellingPoints,
              );
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: yeildData(),
          builder: (context, snap) {
            return SizedBox(
              width: 450,
              height: 435,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: Row(
                        children: [
                          Spacing.addHorizontalSpace(85),
                          Text(Translator.translate(Language.enable)),
                          Radio<int?>(
                            value: 1,
                            groupValue: status,
                            onChanged: (b) {
                              status = b!;
                              curStage++;
                            },
                          ),
                          Spacing.addHorizontalSpace(50),
                          Text(Translator.translate(Language.disable)),
                          Radio<int?>(
                            value: 0,
                            groupValue: status,
                            onChanged: (b) {
                              status = b!;
                              curStage++;
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.nameOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.titleOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: productIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.idOfGood),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: sellingPointController,
                        decoration: InputDecoration(
                          labelText: sellingPoints.isEmpty ? Translator.translate(Language.pressRightButtonToAddSellingPoint) : "",
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.addSellingPointToAdvertisement),
                            icon: const Icon(Icons.add_circle_outlined),
                            onPressed: () {
                              showFillSellingPointDialog(context).then((value) {
                                if (value.isNotEmpty) {
                                  sellingPoints.add(value);
                                  curStage++;
                                }
                              });
                            },
                          ),
                          prefixIcon: Wrap(
                            children: () {
                              List<Widget> widgetList = [];
                              for (var element in sellingPoints) {
                                widgetList.add(Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InputChip(
                                    label: Text(
                                      element,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onDeleted: () {
                                      sellingPoints.remove(element);
                                      curStage++;
                                    },
                                    backgroundColor: Colors.green,
                                    // selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                ));
                              }
                              return widgetList;
                            }(),
                          ),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: sellingPriceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(Config.doubleRegExp),
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.sellingPriceOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: placeOfOriginController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.placeOfOriginOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: stockController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.stockOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: thumbnailController,
                        // decoration: InputDecoration(
                        //   labelText: Translator.translate(Language.thumbnailOfAdvertisement),
                        // ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.pressToModifyThumbnail),
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              var mediaData = await ImagePickerWeb.getImageInfo;
                              if (mediaData != null) {
                                //   imageMap[thumbnailKey] = mediaData;
                                String extension = path.extension(mediaData.fileName!).toLowerCase();
                                imageMap['0'] = ImageItem.construct(
                                  native: true,
                                  data: mediaData.data!,
                                  objectFile: '${advertisement.getId()}/0$extension',
                                  url: '',
                                  nativeFileName: mediaData.fileName!,
                                  key: '',
                                );

                                print('file name: ${mediaData.fileName!}');
                                print('extension: $extension');
                                print('size: ${mediaData.data!.length}');
                                print('object file: ${imageMap['0']!.getObjectFile()}');
                                curStage++;
                              }
                            },
                          ),
                          prefixIcon: Wrap(
                            children: () {
                              List<Widget> widgetList = [];
                              if (imageMap['0'] != null) {
                                var title = '';
                                if (!imageMap['0']!.getNative()) {
                                  title = imageMap['0']!.getKey();
                                } else {
                                  title = imageMap['0']!.getNativeFileName();
                                }
                                widgetList.add(Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InputChip(
                                    label: Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!imageMap['0']!.getNative()) {
                                        showViewNetworkImageDialog(context, imageMap['0']!.getUrl());
                                      } else {
                                        // native
                                        showViewImageDialog(context, imageMap['0']!.getData());
                                      }
                                      // if (imageMap[thumbnailKey] != null) {
                                      //   showViewImageDialog(context, imageMap[thumbnailKey]!.data!);
                                      // }
                                    },
                                    // onDeleted: () {
                                    //   sellingPoints.remove(element);
                                    //   curStage++;
                                    // },
                                    backgroundColor: Colors.green,
                                    // selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                ));
                              }
                              return widgetList;
                            }(),
                          ),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.imageOfAdvertisement),
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
      return value;
    },
  );
}
