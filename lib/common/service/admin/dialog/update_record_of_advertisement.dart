import 'dart:convert';
import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/dashboard/dialog/update_record_of_advertisement_progress.dart';
import 'package:flutter_framework/dashboard/dialog/view_image.dart';
import 'package:flutter_framework/dashboard/dialog/view_network_image.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../../../dashboard/model/advertisement.dart';
import 'package:flutter_framework/common/service/admin/dialog/fill_selling_point.dart';
import '../../../../dashboard/config/config.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_framework/dashboard/local/image_item.dart';

Future<bool> showUpdateRecordOfAdvertisementDialog(BuildContext context, Advertisement advertisement) async {
  var oriObserve = Runtime.getObserve();
  int status = advertisement.getStatus();
  int curStage = 0;
  bool closed = false;
  String from = 'showUpdateRecordOfAdvertisementDialog';
  List<String> sellingPoints = advertisement.getSellingPoints();

  var nameController = TextEditingController(text: advertisement.getName());
  var titleController = TextEditingController(text: advertisement.getTitle());
  var sellingPriceController = TextEditingController(text: Convert.intDivide10toDoubleString(advertisement.getSellingPrice()));
  var placeOfOriginController = TextEditingController(text: advertisement.getPlaceOfOrigin());
  var imageController = TextEditingController(text: '');
  var coverImageController = TextEditingController(text: '');
  var stockController = TextEditingController(text: advertisement.getStock().toString());
  var productIdController = TextEditingController(text: advertisement.getProductId().toString());
  var sellingPointController = TextEditingController();

  ImageItem? oriSecondImage;
  ImageItem? oriThirdImage;
  ImageItem? oriFourthImage;
  ImageItem? oriFifthImage;
  ImageItem oriCoverImage = ImageItem.fromRemote(advertisement.getCoverImage(), advertisement.getOSSPath());
  ImageItem oriFistImage = ImageItem.fromRemote(advertisement.getFirstImage(), advertisement.getOSSPath());
  if (advertisement.getSecondImage().isNotEmpty) {
    oriSecondImage = ImageItem.fromRemote(advertisement.getSecondImage(), advertisement.getOSSPath());
  }
  if (advertisement.getThirdImage().isNotEmpty) {
    oriThirdImage = ImageItem.fromRemote(advertisement.getThirdImage(), advertisement.getOSSPath());
  }
  if (advertisement.getFourthImage().isNotEmpty) {
    oriFourthImage = ImageItem.fromRemote(advertisement.getFourthImage(), advertisement.getOSSPath());
  }
  if (advertisement.getFifthImage().isNotEmpty) {
    oriFifthImage = ImageItem.fromRemote(advertisement.getFifthImage(), advertisement.getOSSPath());
  }

  ImageItem? coverImage = oriCoverImage;
  ImageItem? fistImage = oriFistImage;
  ImageItem? secondImage = oriSecondImage;
  ImageItem? thirdImage = oriThirdImage;
  ImageItem? fourthImage = oriFourthImage;
  ImageItem? fifthImage = oriFifthImage;

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

  void setup() {
    try {
      Runtime.setObserve(observe);
    } catch (e) {
      print('showUpdateRecordOfAdvertisementDialog failure, err: $e');
    }
  }

  setup();

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
              // if (imageMap.length < 2) {
              //   showMessageDialog(
              //     context,
              //     Translator.translate(Language.titleOfNotification),
              //     Translator.translate(Language.imageOfAdvertisementNotProvided),
              //   );
              //   return;
              // }
              // var tempImageMap = () {
              //   Map<String, ImageItem> output = {};
              //   imageMap.forEach(
              //     (key, value) {
              //       output[key] = value;
              //     },
              //   );
              //   return output;
              // }();

              // showUpdateRecordOfAdvertisementProgressDialog(
              //   context,
              //   advertisementId: advertisement.getId(),
              //   name: nameController.text,
              //   stock: int.parse(stockController.text),
              //   status: status,
              //   productId: advertisement.getProductId(),
              //   title: titleController.text,
              //   sellingPrice: Convert.doubleStringMultiple10toInt(sellingPriceController.text),
              //   sellingPoints: sellingPoints,
              //   image: '',
              //   imageMap: tempImageMap,
              //   placeOfOrigin: placeOfOriginController.text,
              //   oriImageMap: oriImageMap,
              //   commonPath: commonPath,
              // ).then(
              //   (value) {
              //     if (value == Code.oK) {
              //       showMessageDialog(
              //         context,
              //         Translator.translate(Language.titleOfNotification),
              //         Translator.translate(Language.updateRecordSuccessfully),
              //       ).then(
              //         (value) {
              //           Navigator.pop(context, true);
              //         },
              //       );
              //     } else {
              //       // error occurs
              //       showMessageDialog(
              //         context,
              //         Translator.translate(Language.titleOfNotification),
              //         '${Translator.translate(Language.failureWithErrorCode)}  $value',
              //       );
              //     }
              //   },
              // );
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
                          labelText: Translator.translate(Language.idOfProduct),
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
                        controller: coverImageController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.pressToModifyCoverImage),
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              var mediaInfo = await ImagePickerWeb.getImageInfo;
                              if (mediaInfo != null) {
                                coverImage = await ImageItem.fromMediaInfo(
                                  mediaInfo: mediaInfo,
                                  prefix: Config.coverImagePrefix,
                                  ossFolder: advertisement.getOSSFolder(),
                                );
                                curStage++;
                              }
                            },
                          ),
                          prefixIcon: Wrap(
                            children: [
                              if (coverImage != null)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InputChip(
                                    label: Text(
                                      () {
                                        var title = '';
                                        if (!coverImage!.getNative()) {
                                          title = coverImage!.getObjectFileName().split('/')[1];
                                        } else {
                                          title = coverImage!.getNativeFileName();
                                        }
                                        return title;
                                      }(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (!coverImage!.getNative()) {
                                        showViewNetworkImageDialog(context, coverImage!.getUrl());
                                      } else {
                                        // native
                                        showViewImageDialog(context, coverImage!.getData());
                                      }
                                    },
                                    backgroundColor: Colors.green,
                                    // selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                )
                            ],
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
                              // var mediaData = await ImagePickerWeb.getImageInfo;
                              // if (mediaData != null) {
                              //   var timestamp = (DateTime.now().millisecondsSinceEpoch) ~/ 1000;
                              //   String extension = path.extension(mediaData.fileName!).toLowerCase();
                              //   var objectFileName = '${advertisement.getId()}/$timestamp$extension';
                              //   imageMap[mediaData.fileName!] = ImageItem.construct(
                              //     native: true,
                              //     data: mediaData.data!,
                              //     objectFileName: objectFileName,
                              //     url: '',
                              //     nativeFileName: mediaData.fileName!,
                              //     // dbKey: '$timestamp',
                              //     width: 0,
                              //     height: 0,
                              //   );
                              //   curStage++;
                              // }
                            },
                          ),
                          prefixIcon: Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: () {
                              List<Widget> widgetList = [];
                              // imageMap.forEach((key, value) {
                              //   // if (key.contains(Config.thumbnailPrefix)) {
                              //   //   return;
                              //   // }
                              //   widgetList.add(Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child: InputChip(
                              //       label: Text(
                              //         key,
                              //         style: const TextStyle(
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       onPressed: () {
                              //         if (imageMap.containsKey(key)) {
                              //           if (imageMap[key]!.getNative()) {
                              //             showViewImageDialog(context, imageMap[key]!.getData());
                              //           } else {
                              //             showViewNetworkImageDialog(context, imageMap[key]!.getUrl());
                              //           }
                              //         }
                              //       },
                              //       onDeleted: () {
                              //         if (imageMap.containsKey(key)) {
                              //           imageMap.remove(key);
                              //         }
                              //         curStage++;
                              //       },
                              //       backgroundColor: Colors.green,
                              //       // selectedColor: Colors.green,
                              //       elevation: 6.0,
                              //       shadowColor: Colors.grey[60],
                              //       padding: const EdgeInsets.all(8.0),
                              //     ),
                              //   ));
                              // });
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
