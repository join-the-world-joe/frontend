class Product {
  static const fetchIdListOfProductReq = "1";
  static const fetchIdListOfProductRsp = "2";
  static const fetchRecordsOfProductReq = "3";
  static const fetchRecordsOfProductRsp = "4";

  String getName({required String minor}) {
    switch (minor) {
      case fetchIdListOfProductReq:
        return 'fetchIdListOfProductReq';
      case fetchIdListOfProductRsp:
        return 'fetchIdListOfProductRsp';
      case fetchRecordsOfProductReq:
        return 'fetchRecordsOfProductReq';
      case fetchRecordsOfProductRsp:
        return 'fetchRecordsOfProductRsp';
      default:
        return 'unknown';
    }
  }
}
