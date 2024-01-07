import 'package:flutter_framework/dashboard/model/ad_of_carousel.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/convert.dart';

class FetchRecordsOfADOfCarouselReq {
  List<int> _advertisementIdList = [];

  FetchRecordsOfADOfCarouselReq.construct({
    required List<int> advertisementIdList,
  }) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {"advertisement_id_list": _advertisementIdList};
  }
}

class FetchRecordsOfADOfCarouselRsp {
  int _code = Code.internalError;
  Map<int, ADOfCarousel> _dataMap = {};

  int getCode() {
    return _code;
  }

  Map<int, ADOfCarousel> getDataMap() {
    return _dataMap;
  }

  FetchRecordsOfADOfCarouselRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }

    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('records_of_ad_of_carousel')) {
        List<dynamic> some = body['records_of_ad_of_carousel'];
        for (var element in some) {
          _dataMap[element['advertisement_id']] = ADOfCarousel.construct(
            advertisementId: element['advertisement_id'],
            advertisementName: element['advertisement_name'],
            title: element['title'],
            stock: element['stock'],
            status: element['status'],
            sellingPrice: element['selling_price'],
            productId: element['product_id'],
            productName: element['product_name'],
            placeOfOrigin: element['place_of_origin'],
            sellingPoints: Convert.base64StringList2ListString(List<String>.from(element['selling_points'] as List)),
            coverImage: element['cover_image'],
            firstImage: element['first_image'],
            secondImage: element['second_image'],
            thirdImage: element['third_image'],
            fourthImage: element['fourth_image'],
            fifthImage: element['fifth_image'],
            ossPath: element['oss_path'],
          );
        }
      }
    }
  }
}
