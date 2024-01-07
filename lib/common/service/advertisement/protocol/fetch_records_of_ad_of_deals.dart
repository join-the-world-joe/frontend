import 'package:flutter_framework/dashboard/model/ad_of_deals.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/utils/convert.dart';

class FetchRecordsOfADOfDealsReq {
  List<int> _advertisementIdList = [];

  FetchRecordsOfADOfDealsReq.construct({
    required List<int> advertisementIdList,
  }) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {"advertisement_id_list": _advertisementIdList};
  }
}

class FetchRecordsOfADOfDealsRsp {
  int _code = Code.internalError;
  Map<int, ADOfDeals> _dataMap = {};

  int getCode() {
    return _code;
  }

  Map<int, ADOfDeals> getDataMap() {
    return _dataMap;
  }

  FetchRecordsOfADOfDealsRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }

    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('records_of_ad_of_deals')) {
        // print("body: ${body['records_of_advertisement']}");
        List<dynamic> some = body['records_of_ad_of_deals'];
        // final some = Map.from(body['records_of_ad_of_deals']);
        // print('some: $some');
        for (var element in some) {
          // print('${Convert.base64StringList2ListString(List<String>.from(element['selling_points'] as List))}');
          _dataMap[element['advertisement_id']] = ADOfDeals.construct(
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
      // some.forEach(
      //       (key, value) {
      //     _dataMap[int.parse(key)] = ADOfDeals.construct(
      //       advertisementId: value['advertisement_id'],
      //       advertisementName: value['advertisement_name'],
      //       title: value['title'],
      //       stock: value['stock'],
      //       sellingPrice: value['selling_price'],
      //       productId: value['product_id'],
      //       productName: value['product_name'],
      //       description: value['description'],
      //       placeOfOrigin: value['place_of_origin'],
      //       sellingPoints: Convert.base64StringList2ListString(List<String>.from(value['selling_points'] as List)),
      //       imagePath: value['image_path'],
      //     );
      //   },
      // );
    }
  }
}
