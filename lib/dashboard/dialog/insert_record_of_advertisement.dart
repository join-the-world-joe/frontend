import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/product.dart';
import 'package:flutter_framework/dashboard/dialog/fill_selling_point.dart';
import 'package:flutter_framework/dashboard/dialog/insert_record_of_advertisement_progress.dart';
import 'package:flutter_framework/dashboard/dialog/view_image.dart';
import 'package:flutter_framework/dashboard/local/image_item.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_product.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_product.dart';
import 'package:image_picker_web/image_picker_web.dart';

Future<void> showInsertRecordOfAdvertisementDialog(BuildContext context) async {
  bool closed = false;
  int curStage = 0;
  String from = 'showInsertRecordOfAdvertisementDialog';
  List<String> sellingPoints = [];
  var oriObserve = Runtime.getObserve();
  var productIdController = TextEditingController();
  var nameController = TextEditingController();
  var titleController = TextEditingController();
  var sellingPriceController = TextEditingController();
  var placeOfOriginController = TextEditingController();
  var sellingPointController = TextEditingController();
  var stockController = TextEditingController();
  var coverImageController = TextEditingController();
  var firstImageController = TextEditingController();
  var secondImageController = TextEditingController();
  var thirdImageController = TextEditingController();
  var fourthImageController = TextEditingController();
  var fifthImageController = TextEditingController();
  ImageItem? coverImage;
  ImageItem? firstImage;
  ImageItem? secondImage;
  ImageItem? thirdImage;
  ImageItem? fourthImage;
  ImageItem? fifthImage;

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showInsertAdvertisementDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void fetchRecordsOfProductHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRecordsOfProductHandler';
    try {
      var rsp = FetchRecordsOfProductRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: '',
      );
      if (rsp.getCode() == Code.oK) {
        var key = int.parse(productIdController.text);
        if (rsp.getDataMap().containsKey(key)) {
          showMessageDialog(
            context,
            Translator.translate(Language.nameOfProduct),
            rsp.getDataMap()[key]!.getName(),
          );
          curStage++;
        } else {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.withoutProductInfoInResponse),
          );
        }
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
    }
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
        from: from,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.product && minor == Product.fetchRecordsOfProductRsp) {
        fetchRecordsOfProductHandler(major: major, minor: minor, body: body);
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
    } finally {}
  }

  Widget productIdComponent() {
    var caller = 'productIdComponent';
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: productIdController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
          LengthLimitingTextInputFormatter(11),
        ],
        decoration: InputDecoration(
          labelText: Translator.translate(Language.idOfProduct),
          labelStyle: const TextStyle(
            color: Colors.redAccent,
          ),
          suffixIcon: IconButton(
            tooltip: Translator.translate(Language.peekInfoFromProductId),
            icon: const Icon(Icons.search),
            onPressed: () {
              if (productIdController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.productIdIsEmpty),
                );
                return;
              } else {
                fetchRecordsOfProduct(
                  from: from,
                  caller: caller,
                  productIdList: [int.parse(productIdController.text)],
                );
                return;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget advertisementNameComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            color: Colors.redAccent,
          ),
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

  Widget coverImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: coverImageController,
        decoration: InputDecoration(
          labelText: coverImage == null ? Translator.translate(Language.pressRightButtonToAddCoverImage) : '',
          suffixIcon: IconButton(
            tooltip: () {
              if (coverImage == null) {
                return Translator.translate(Language.pressToAddCoverImage);
              } else {
                return Translator.translate(Language.pressToModifyCoverImage);
              }
            }(),
            icon: coverImage == null ? const Icon(Icons.add_circle_outlined) : const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                coverImage = await ImageItem.fromMediaInfo(mediaInfo: mediaInfo, prefix: Config.coverImagePrefix);
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
                      coverImage!.getNativeFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (coverImage != null) {
                        showViewImageDialog(context, coverImage!.getData());
                      }
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
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget firstImageComponent() {
    return SizedBox(
      width: 350,
      child: TextFormField(
        readOnly: true,
        controller: firstImageController,
        decoration: InputDecoration(
          labelText: firstImage == null ? Translator.translate(Language.pressRightButtonToAddFirstImage) : '',
          suffixIcon: IconButton(
            tooltip: () {
              if (firstImage == null) {
                return Translator.translate(Language.pressToAddFirstImage);
              } else {
                return Translator.translate(Language.pressToModifyFirstImage);
              }
            }(),
            icon: firstImage == null ? const Icon(Icons.add_circle_outlined) : const Icon(Icons.edit),
            onPressed: () async {
              var mediaInfo = await ImagePickerWeb.getImageInfo;
              if (mediaInfo != null) {
                firstImage = await ImageItem.fromMediaInfo(mediaInfo: mediaInfo, prefix: Config.firstImagePrefix);
                curStage++;
              }
            },
          ),
          prefixIcon: Wrap(
            children: [
              if (firstImage != null)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InputChip(
                    label: Text(
                      firstImage!.getNativeFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (firstImage != null) {
                        showViewImageDialog(context, firstImage!.getData());
                      }
                    },
                    onDeleted: () {
                      firstImage = null;
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
                secondImage = await ImageItem.fromMediaInfo(mediaInfo: mediaInfo, prefix: Config.secondImagePrefix);
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
                      secondImage!.getNativeFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (secondImage != null) {
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
    if (firstImage != null) {
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
                thirdImage = await ImageItem.fromMediaInfo(mediaInfo: mediaInfo, prefix: Config.thirdImagePrefix);
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
                      thirdImage!.getNativeFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (thirdImage != null) {
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
    if (firstImage != null && secondImage != null) {
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
                fourthImage = await ImageItem.fromMediaInfo(mediaInfo: mediaInfo, prefix: Config.fourthImagePrefix);
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
                      fourthImage!.getNativeFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (fourthImage != null) {
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
    if (firstImage != null && secondImage != null && thirdImage != null) {
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
                fifthImage = await ImageItem.fromMediaInfo(mediaInfo: mediaInfo, prefix: Config.fifthImagePrefix);
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
                      fifthImage!.getNativeFileName(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (fifthImage != null) {
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
    if (firstImage != null && secondImage != null && thirdImage != null && fourthImage != null) {
      widgets.add(fifthImageComponent());
      widgets.add(Spacing.addVerticalSpace(10));
    }
    return widgets;
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        title: Text(Translator.translate(Language.editAdvertisement)),
        actions: [
          TextButton(
            child: Text(Translator.translate(Language.cancel)),
            onPressed: () => Navigator.pop(context, null),
          ),
          TextButton(
            child: Text(Translator.translate(Language.titleOfInsertAdvertisementButton)),
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

              if (coverImage == null) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.coverImageOfAdvertisementNotProvided),
                );
                return;
              }
              if (firstImage == null) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.imageOfAdvertisementNotProvided),
                );
                return;
              }
              showInsertRecordOfAdvertisementProgressDialog(
                context,
                name: nameController.text,
                title: titleController.text,
                stock: int.parse(stockController.text),
                productId: int.parse(productIdController.text),
                placeOfOrigin: placeOfOriginController.text,
                sellingPoints: sellingPoints,
                sellingPrice: Convert.doubleStringMultiple10toInt(sellingPriceController.text),
                coverImage: coverImage,
                firstImage: firstImage,
                secondImage: secondImage,
                thirdImage: thirdImage,
                fourthImage: fourthImage,
                fifthImage: fifthImage,
              ).then((value) {
                if (value == Code.oK) {
                  showMessageDialog(
                    context,
                    Translator.translate(Language.titleOfNotification),
                    Translator.translate(Language.insertRecordSuccessfully),
                  ).then(
                    (value) {
                      Navigator.pop(context, null);
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
              });
            },
          ),
          // Spacing.AddVerticalSpace(50),
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
                    productIdComponent(),
                    Spacing.addVerticalSpace(10),
                    advertisementNameComponent(),
                    Spacing.addVerticalSpace(10),
                    titleComponent(),
                    Spacing.addVerticalSpace(10),
                    sellingPointsComponent(),
                    Spacing.addVerticalSpace(10),
                    sellingPriceComponent(),
                    Spacing.addVerticalSpace(10),
                    stockComponent(),
                    Spacing.addVerticalSpace(10),
                    placeOfOriginComponent(),
                    Spacing.addVerticalSpace(10),
                    coverImageComponent(),
                    Spacing.addVerticalSpace(10),
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
    },
  );
}
