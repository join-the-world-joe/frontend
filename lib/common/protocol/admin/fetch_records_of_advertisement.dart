import '../../../utils/convert.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';

class FetchRecordsOfAdvertisementReq {
  List<int> _advertisementIdList = [];

  FetchRecordsOfAdvertisementReq.construct({required List<int> advertisementIdList}) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisement_id_list': _advertisementIdList,
    };
  }
}

class FetchRecordsOfAdvertisementRsp {
  int code = -1;
  Map<int, Advertisement> advertisementMap = {};

  int getCode() {
    return code;
  }

  Map<int, Advertisement> getAdvertisementMap() {
    return advertisementMap;
  }

  FetchRecordsOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('records_of_advertisement')) {
        // print("body: ${body['records_of_advertisement']}");
        final some = Map.from(body['records_of_advertisement']);
        // print('some: $some');
        some.forEach(
              (key, value) {
            advertisementMap[int.parse(key)] = Advertisement.construct(
              id: int.parse(key),
              name: value['name'],
              title: value['title'],
              placeOfOrigin: value['place_of_origin'],
              sellingPoints: Convert.base64StringList2ListString(List<String>.from(value['selling_points'] as List)),
              url: value['url'],
              sellingPrice: value['selling_price'],
              description: value['description'],
              status: value['status'],
              stock: value['stock'],
              productId: value['product_id'],
            );
          },
        );
      }
    }
  }
}