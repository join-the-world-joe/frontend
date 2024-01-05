import 'dart:convert';
import 'dart:convert';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';
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

  List<String> nameListOfFile = []; // object file to be uploaded
  List<String> objectFileToBeRemoved = [];
  Map<String, Uint8List> objectDataMapping = {}; // key: object file name, value: native file name
  Map<String, ObjectFileRequestHeader> requestHeader = {}; // key: object file name

  var nameController = TextEditingController(text: advertisement.getName());
  var titleController = TextEditingController(text: advertisement.getTitle());
  var sellingPriceController = TextEditingController(text: Convert.intDivide10toDoubleString(advertisement.getSellingPrice()));
  var placeOfOriginController = TextEditingController(text: advertisement.getPlaceOfOrigin());
  var coverImageController = TextEditingController(text: '');
  var firstImageController = TextEditingController(text: '');
  var secondImageController = TextEditingController(text: '');
  var thirdImageController = TextEditingController(text: '');
  var fourthImageController = TextEditingController(text: '');
  var fifthImageController = TextEditingController(text: '');
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

  ImageItem coverImage = oriCoverImage;
  ImageItem firstImage = oriFistImage;
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

  void figureOutArgument() {
    nameListOfFile = [];
    objectFileToBeRemoved = [];
    objectDataMapping = {};
    requestHeader = {};
    if (coverImage.getNative()) {
      nameListOfFile.add(coverImage.getObjectFileName());
      objectFileToBeRemoved.add(oriCoverImage.getObjectFileName());
      objectDataMapping[coverImage.getObjectFileName()] = coverImage.getData();
    }

    if (firstImage.getNative()) {
      nameListOfFile.add(firstImage.getObjectFileName());
      objectFileToBeRemoved.add(oriFistImage.getObjectFileName());
      objectDataMapping[firstImage.getObjectFileName()] = firstImage.getData();
    }

    if (secondImage != null) {
      if (secondImage!.getNative()) {
        nameListOfFile.add(secondImage!.getObjectFileName());
        objectFileToBeRemoved.add(oriSecondImage!.getObjectFileName());
        objectDataMapping[secondImage!.getObjectFileName()] = secondImage!.getData();
      }
      if (thirdImage != null) {
        if (thirdImage!.getNative()) {
          nameListOfFile.add(thirdImage!.getObjectFileName());
          objectFileToBeRemoved.add(oriThirdImage!.getObjectFileName());
          objectDataMapping[thirdImage!.getObjectFileName()] = thirdImage!.getData();
        }
        if (fourthImage != null) {
          if (fourthImage!.getNative()) {
            nameListOfFile.add(fourthImage!.getObjectFileName());
            objectFileToBeRemoved.add(oriFourthImage!.getObjectFileName());
            objectDataMapping[fourthImage!.getObjectFileName()] = fourthImage!.getData();
          }
          if (fifthImage != null) {
            if (fifthImage!.getNative()) {
              nameListOfFile.add(fifthImage!.getObjectFileName());
              objectFileToBeRemoved.add(oriFifthImage!.getObjectFileName());
              objectDataMapping[fifthImage!.getObjectFileName()] = fifthImage!.getData();
            }
          }
        }
      }
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

  Widget placeOfOriginComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: placeOfOriginController,
        decoration: InputDecoration(
          labelText: Translator.translate(Language.placeOfOriginOfAdvertisement),
        ),
      ),
    );
  }

  Widget statusComponent() {
    return SizedBox(
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
    );
  }

  Widget nameComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: Translator.translate(Language.nameOfAdvertisement),
        ),
      ),
    );
  }

  Widget titleComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: titleController,
        decoration: InputDecoration(
          labelText: Translator.translate(Language.titleOfAdvertisement),
        ),
      ),
    );
  }

  Widget productIdComponent() {
    return SizedBox(
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
    );
  }

  Widget sellingPriceComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: sellingPriceController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(Config.doubleRegExp),
          LengthLimitingTextInputFormatter(Config.lengthOfSellingPrice),
        ],
        decoration: InputDecoration(
          labelText: Translator.translate(Language.sellingPriceOfAdvertisement),
        ),
      ),
    );
  }

  Widget sellingPointsComponent() {
    return SizedBox(
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
    );
  }

  Widget stockComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: stockController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(Config.lengthOfBuyingPrice),
        ],
        decoration: InputDecoration(
          labelText: Translator.translate(Language.stockOfAdvertisement),
        ),
      ),
    );
  }

  Widget coverImageComponent() {
    return SizedBox(
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
                  prefix: Config.firstImagePrefix,
                  ossFolder: advertisement.getOSSFolder(),
                );
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InputChip(
                  label: Text(
                    () {
                      var title = '';
                      if (!coverImage.getNative()) {
                        title = coverImage.getObjectFileName().split('/')[1];
                      } else {
                        title = coverImage.getNativeFileName();
                      }
                      return title;
                    }(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (!coverImage.getNative()) {
                      showViewNetworkImageDialog(context, coverImage.getUrl());
                    } else {
                      // native
                      showViewImageDialog(context, coverImage.getData());
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
    );
  }

  List<Widget> coverImageComponentList() {
    List<Widget> widgets = [];
    widgets.add(coverImageComponent());
    widgets.add(Spacing.addVerticalSpace(10));
    return widgets;
  }

  Widget firstImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: firstImageController,
        decoration: InputDecoration(
          // labelText: firstImage == null ? Translator.translate(Language.pressRightButtonToAddFirstImage) : '',
          suffixIcon: IconButton(
            tooltip: Translator.translate(Language.pressToModifyFirstImage),
            icon: const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                firstImage = await ImageItem.fromMediaInfo(
                  mediaInfo: mediaInfo,
                  prefix: Config.firstImagePrefix,
                  ossFolder: advertisement.getOSSFolder(),
                );
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InputChip(
                  label: Text(
                    () {
                      var title = '';
                      if (!firstImage.getNative()) {
                        title = firstImage.getObjectFileName().split('/')[1];
                      } else {
                        title = firstImage.getNativeFileName();
                      }
                      return title;
                    }(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (!firstImage.getNative()) {
                      showViewNetworkImageDialog(context, firstImage.getUrl());
                    } else {
                      // native
                      showViewImageDialog(context, firstImage.getData());
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
    );
  }

  List<Widget> firstImageComponentList() {
    List<Widget> widgets = [];
    widgets.add(firstImageComponent());
    widgets.add(Spacing.addVerticalSpace(10));
    return widgets;
  }

  Widget secondImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: secondImageController,
        decoration: InputDecoration(
          labelText: secondImage == null ? Translator.translate(Language.pressRightButtonToAddSecondImage) : '',
          suffixIcon: IconButton(
            tooltip: () {
              if (secondImage == null) {
                return Translator.translate(Language.pressToAddSecondImage);
              } else {
                return Translator.translate(Language.pressToModifySecondImage);
              }
            }(),
            icon: secondImage == null ? const Icon(Icons.add_circle_outlined) : const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                secondImage = await ImageItem.fromMediaInfo(
                  mediaInfo: mediaInfo,
                  prefix: Config.secondImagePrefix,
                  ossFolder: advertisement.getOSSFolder(),
                );
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              if (secondImage != null)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputChip(
                    label: Text(
                      () {
                        var title = '';
                        if (!secondImage!.getNative()) {
                          title = secondImage!.getObjectFileName().split('/')[1];
                        } else {
                          title = secondImage!.getNativeFileName();
                        }
                        return title;
                      }(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (!secondImage!.getNative()) {
                        showViewNetworkImageDialog(context, secondImage!.getUrl());
                      } else {
                        // native
                        showViewImageDialog(context, secondImage!.getData());
                      }
                    },
                    onDeleted: () {
                      secondImage = null;
                      curStage++;
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
    );
  }

  List<Widget> secondImageComponentList() {
    List<Widget> widgets = [];
    if (secondImage != null) {
      widgets.add(secondImageComponent());
      widgets.add(Spacing.addVerticalSpace(10));
    }
    return widgets;
  }

  Widget thirdImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: thirdImageController,
        decoration: InputDecoration(
          labelText: thirdImage == null ? Translator.translate(Language.pressRightButtonToAddThirdImage) : '',
          suffixIcon: IconButton(
            tooltip: () {
              if (thirdImage == null) {
                return Translator.translate(Language.pressToAddThirdImage);
              } else {
                return Translator.translate(Language.pressToModifyThirdImage);
              }
            }(),
            icon: thirdImage == null ? const Icon(Icons.add_circle_outlined) : const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                thirdImage = await ImageItem.fromMediaInfo(
                  mediaInfo: mediaInfo,
                  prefix: Config.thirdImagePrefix,
                  ossFolder: advertisement.getOSSFolder(),
                );
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              if (thirdImage != null)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputChip(
                    label: Text(
                      () {
                        var title = '';
                        if (!thirdImage!.getNative()) {
                          title = thirdImage!.getObjectFileName().split('/')[1];
                        } else {
                          title = thirdImage!.getNativeFileName();
                        }
                        return title;
                      }(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (!thirdImage!.getNative()) {
                        showViewNetworkImageDialog(context, thirdImage!.getUrl());
                      } else {
                        // native
                        showViewImageDialog(context, thirdImage!.getData());
                      }
                    },
                    onDeleted: () {
                      thirdImage = null;
                      curStage++;
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
    );
  }

  List<Widget> thirdImageComponentList() {
    List<Widget> widgets = [];
    if (secondImage != null && thirdImage != null) {
      widgets.add(thirdImageComponent());
      widgets.add(Spacing.addVerticalSpace(10));
    }
    return widgets;
  }

  Widget fourthImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: fourthImageController,
        decoration: InputDecoration(
          labelText: fourthImage == null ? Translator.translate(Language.pressRightButtonToAddFourthImage) : '',
          suffixIcon: IconButton(
            tooltip: () {
              if (fourthImage == null) {
                return Translator.translate(Language.pressToAddFourthImage);
              } else {
                return Translator.translate(Language.pressToModifyFourthImage);
              }
            }(),
            icon: fourthImage == null ? const Icon(Icons.add_circle_outlined) : const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                fourthImage = await ImageItem.fromMediaInfo(
                  mediaInfo: mediaInfo,
                  prefix: Config.fourthImagePrefix,
                  ossFolder: advertisement.getOSSFolder(),
                );
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              if (fourthImage != null)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputChip(
                    label: Text(
                      () {
                        var title = '';
                        if (!fourthImage!.getNative()) {
                          title = fourthImage!.getObjectFileName().split('/')[1];
                        } else {
                          title = fourthImage!.getNativeFileName();
                        }
                        return title;
                      }(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (!fourthImage!.getNative()) {
                        showViewNetworkImageDialog(context, fourthImage!.getUrl());
                      } else {
                        // native
                        showViewImageDialog(context, fourthImage!.getData());
                      }
                    },
                    onDeleted: () {
                      fourthImage = null;
                      curStage++;
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
    );
  }

  List<Widget> fourthImageComponentList() {
    List<Widget> widgets = [];
    if (secondImage != null && thirdImage != null && fourthImage != null) {
      widgets.add(fourthImageComponent());
      widgets.add(Spacing.addVerticalSpace(10));
    }
    return widgets;
  }

  Widget fifthImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: fifthImageController,
        decoration: InputDecoration(
          labelText: fifthImage == null ? Translator.translate(Language.pressRightButtonToAddFifthImage) : '',
          suffixIcon: IconButton(
            tooltip: () {
              if (fifthImage == null) {
                return Translator.translate(Language.pressToAddFifthImage);
              } else {
                return Translator.translate(Language.pressToModifyFifthImage);
              }
            }(),
            icon: fifthImage == null ? const Icon(Icons.add_circle_outlined) : const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                fifthImage = await ImageItem.fromMediaInfo(
                  mediaInfo: mediaInfo,
                  prefix: Config.fifthImagePrefix,
                  ossFolder: advertisement.getOSSFolder(),
                );
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              if (fifthImage != null)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputChip(
                    label: Text(
                      () {
                        var title = '';
                        if (!fifthImage!.getNative()) {
                          title = fifthImage!.getObjectFileName().split('/')[1];
                        } else {
                          title = fifthImage!.getNativeFileName();
                        }
                        return title;
                      }(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (!fifthImage!.getNative()) {
                        showViewNetworkImageDialog(context, fifthImage!.getUrl());
                      } else {
                        // native
                        showViewImageDialog(context, fifthImage!.getData());
                      }
                    },
                    onDeleted: () {
                      fifthImage = null;
                      curStage++;
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
    );
  }

  List<Widget> fifthImageComponentList() {
    List<Widget> widgets = [];
    if (secondImage != null && thirdImage != null && fourthImage != null && fifthImage != null) {
      widgets.add(fifthImageComponent());
      widgets.add(Spacing.addVerticalSpace(10));
    }
    return widgets;
  }

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

              // figure out name list of object file
              figureOutArgument();

              print("name list of file: $nameListOfFile");
              print("object file to be removed: $objectFileToBeRemoved");

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
                    statusComponent(),
                    Spacing.addVerticalSpace(10),
                    nameComponent(),
                    Spacing.addVerticalSpace(10),
                    titleComponent(),
                    Spacing.addVerticalSpace(10),
                    productIdComponent(),
                    Spacing.addVerticalSpace(10),
                    sellingPointsComponent(),
                    Spacing.addVerticalSpace(10),
                    sellingPriceComponent(),
                    Spacing.addVerticalSpace(10),
                    stockComponent(),
                    Spacing.addVerticalSpace(10),
                    placeOfOriginComponent(),
                    Spacing.addVerticalSpace(10),
                    ...coverImageComponentList(),
                    ...firstImageComponentList(),
                    ...secondImageComponentList(),
                    ...thirdImageComponentList(),
                    ...fourthImageComponentList(),
                    ...fifthImageComponentList(),
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
