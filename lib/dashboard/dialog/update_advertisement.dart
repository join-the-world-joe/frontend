import 'dart:convert';
import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_advertisement.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/dashboard/dialog/update_advertisement_progress.dart';
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
import 'package:flutter_framework/dashboard/local/image_item.dart';

/*
use cases
1. delete image; modify original record
2. add new image; need to upload image
3. delete image & add new image; modify record & need to upload image

optimization
1. frontend provides the remove key list for backend
2. frontend use the update interface to modify the specific record
 */

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
  Map<String, ImageItem> imageMap = {}; // key: key of advertisement in database or native file name
  Map<String, ImageItem> oriImageMap = {}; // key: key of advertisement in database
  var thumbnailKey = 'thumbnail';
  var commonPath = '';

  try {
    String extension = '';
    var oriObjectFileName = '';
    Map<String, dynamic> image = jsonDecode(advertisement.getImage());
    image.forEach((key, value) {
      extension = path.extension(value).toLowerCase();
      oriObjectFileName = '${advertisement.getId()}/$key$extension';
      imageMap[key] = ImageItem.construct(
        native: false,
        data: Uint8List(0),
        objectFile: oriObjectFileName,
        url: value,
        nativeFileName: '',
        dbKey: key,
      );
      oriImageMap[key] = imageMap[key]!;
    });
    if (imageMap.containsKey('0')) {
      extension = path.extension(imageMap['0']!.getUrl()).toLowerCase();
      commonPath = imageMap['0']!.getUrl().split('${advertisement.getId()}/0$extension')[0];
      imageMap[thumbnailKey] = imageMap['0']!;
      imageMap.remove('0');
    }
  } catch (e) {
    print('showUpdateAdvertisementDialog failure, err: $e');
  } finally {
    // print('Original Image map: ');
    // oriImageMap.forEach(
    //   (key, value) {
    //     print('key: $key, dbKey: ${value.getDBKey()}, objectFile: ${value.getObjectFile()}, url: ${value.getUrl()}');
    //   },
    // );
    // print('Image map: ');
    // imageMap.forEach(
    //   (key, value) {
    //     print('key: $key, dbKey: ${value.getDBKey()}, objectFile: ${value.getObjectFile()}, url: ${value.getUrl()}');
    //   },
    // );
  }

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
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: '',
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
              if (productIdController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.productIdIsEmpty),
                );
                return;
              }
              if (nameController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.nameOfAdvertisementIsEmpty),
                );
                return;
              }
              if (stockController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.incorrectStockValueInController),
                );
                return;
              }

              if (sellingPriceController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.incorrectSellingPriceInController),
                );
                return;
              }
              if (!imageMap.containsKey(thumbnailKey)) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.thumbnailOfAdvertisementNotProvided),
                );
                return;
              }
              if (imageMap.length < 2) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.imageOfAdvertisementNotProvided),
                );
                return;
              }

              // imageMap['0'] = imageMap[thumbnailKey]!;
              // imageMap.remove(thumbnailKey);

              var tempImageMap = () {
                Map<String, ImageItem> output = {};
                imageMap.forEach(
                  (key, value) {
                    output[key] = value;
                  },
                );
                output['0'] = output[thumbnailKey]!;
                output.remove(thumbnailKey);
                return output;
              }();

              showUpdateAdvertisementProgressDialog(
                context,
                advertisementId: advertisement.getId(),
                name: nameController.text,
                stock: int.parse(stockController.text),
                status: status,
                productId: advertisement.getProductId(),
                title: titleController.text,
                sellingPrice: Convert.doubleStringMultiple10toInt(sellingPriceController.text),
                sellingPoints: sellingPoints,
                thumbnailKey: thumbnailKey,
                image: advertisement.getImage(),
                imageMap: tempImageMap,
                placeOfOrigin: placeOfOriginController.text,
                oriImageMap: oriImageMap,
                commonPath: commonPath,
              ).then(
                (value) {
                  if (value == Code.oK) {
                    showMessageDialog(
                      context,
                      Translator.translate(Language.titleOfNotification),
                      Translator.translate(Language.insertRecordSuccessfully),
                    ).then(
                      (value) {
                        Navigator.pop(context, true);
                      },
                    );
                  } else {
                    // error occurs
                    showMessageDialog(
                      context,
                      Translator.translate(Language.titleOfNotification),
                      '${Translator.translate(Language.failureWithErrorCode)}  $value',
                    );
                  }
                },
              );
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: stream(),
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
                                imageMap[thumbnailKey] = ImageItem.construct(
                                  native: true,
                                  data: mediaData.data!,
                                  objectFile: '${advertisement.getId()}/0$extension',
                                  url: '',
                                  nativeFileName: mediaData.fileName!,
                                  dbKey: '0',
                                );

                                // print('thumbnail file name: ${mediaData.fileName!}');
                                // print('thumbnail extension: $extension');
                                // print('thumbnail size: ${mediaData.data!.length}');
                                // print('thumbnail object file: ${imageMap[thumbnailKey]!.getObjectFile()}');
                                curStage++;
                              }
                            },
                          ),
                          prefixIcon: Wrap(
                            children: () {
                              List<Widget> widgetList = [];
                              if (imageMap[thumbnailKey] != null) {
                                var title = '';
                                if (!imageMap[thumbnailKey]!.getNative()) {
                                  title = imageMap[thumbnailKey]!.getDBKey();
                                } else {
                                  title = imageMap[thumbnailKey]!.getNativeFileName();
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
                                      if (!imageMap[thumbnailKey]!.getNative()) {
                                        showViewNetworkImageDialog(context, imageMap[thumbnailKey]!.getUrl());
                                      } else {
                                        // native
                                        showViewImageDialog(context, imageMap[thumbnailKey]!.getData());
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
                        readOnly: true,
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: '',
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.addImageForAdvertisement),
                            icon: const Icon(Icons.add_circle_outlined),
                            onPressed: () async {
                              var mediaData = await ImagePickerWeb.getImageInfo;
                              if (mediaData != null) {
                                var timestamp = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
                                String extension = path.extension(mediaData.fileName!).toLowerCase();
                                var objectFileName = '${advertisement.getId()}/$timestamp$extension';
                                // print('key: $timestamp');
                                // print('file name: ${mediaData.fileName!}');
                                // print('object file name: $objectFileName');
                                // print('extension: $extension');
                                // print('size: ${mediaData.data!.length}');
                                // imageMap[mediaData.fileName!] = mediaData;
                                // imageList.add(mediaData.fileName!);
                                imageMap[mediaData.fileName!] = ImageItem.construct(
                                  native: true,
                                  data: mediaData.data!,
                                  objectFile: objectFileName,
                                  url: '',
                                  nativeFileName: mediaData.fileName!,
                                  dbKey: '$timestamp',
                                );
                                curStage++;
                              }
                            },
                          ),
                          prefixIcon: Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: () {
                              List<Widget> widgetList = [];
                              imageMap.forEach((key, value) {
                                if (key.compareTo(thumbnailKey) == 0) {
                                  return;
                                }
                                widgetList.add(Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InputChip(
                                    label: Text(
                                      key,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (imageMap.containsKey(key)) {
                                        if (imageMap[key]!.getNative()) {
                                          showViewImageDialog(context, imageMap[key]!.getData());
                                        } else {
                                          showViewNetworkImageDialog(context, imageMap[key]!.getUrl());
                                        }
                                      }
                                    },
                                    onDeleted: () {
                                      imageMap.remove(key);
                                      if (imageMap.containsKey(key)) {
                                        imageMap.remove(key);
                                      }
                                      curStage++;
                                    },
                                    backgroundColor: Colors.green,
                                    // selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                ));
                              });
                              return widgetList;
                            }(),
                          ),
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
