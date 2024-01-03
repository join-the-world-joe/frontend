import '../../../../utils/convert.dart';
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
  int _code = -1;
  Map<int, Advertisement> _dataMap = {};

  int getCode() {
    return _code;
  }

  Map<int, Advertisement> getDataMap() {
    return _dataMap;
  }

  FetchRecordsOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('records_of_advertisement')) {
        // print("body: ${body['records_of_advertisement']}");
        final some = Map.from(body['records_of_advertisement']);
        // print('some: $some');
        some.forEach(
          (key, value) {
            _dataMap[int.parse(key)] = Advertisement.construct(
              id: int.parse(key),
              name: value['name'],
              title: value['title'],
              placeOfOrigin: value['place_of_origin'],
              sellingPoints: Convert.base64StringList2ListString(List<String>.from(value['selling_points'] as List)),
              coverImage: value['cover_image'],
              firstImage: value['first_image'],
              secondImage: value['second_image'],
              thirdImage: value['third_image'],
              fourthImage: value['fourth_image'],
              fifthImage: value['fifth_image'],
              sellingPrice: value['selling_price'],
              stock: value['stock'],
              status: value['status'],
              productId: value['product_id'],
            );
          },
        );
      }
    }
  }
}
