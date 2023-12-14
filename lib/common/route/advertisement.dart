class Advertisement {
  static const String fetchVersionOfADOfCarouselReq = "1";
  static const String fetchVersionOfADOfCarouselRsp = "2";
  static const String fetchIdListOfADOfCarouselReq = "3";
  static const String fetchIdListOfADOfCarouselRsp = "4";
  static const String fetchRecordsOfADOfCarouselReq = "5";
  static const String fetchRecordsOfADOfCarouselRsp = "6";
  static const String fetchVersionOfADOfDealsReq = "7";
  static const String fetchVersionOfADOfDealsRsp = "8";
  static const String fetchIdListOfADOfDealsReq = "9";
  static const String fetchIdListOfADOfDealsRsp = "10";
  static const String fetchRecordsOfADOfDealsReq = "11";
  static const String fetchRecordsOfADOfDealsRsp = "12";
  static const String fetchVersionOfADOfHotsReq = "13";
  static const String fetchVersionOfADOfHotsRsp = "14";
  static const String fetchIdListOfADOfHotsReq = "15";
  static const String fetchIdListOfADOfHotsRsp = "16";
  static const String fetchRecordsOfADOfHotsReq = "17";
  static const String fetchRecordsOfADOfHotsRsp = "18";
  static const String fetchVersionOfADOfBarbecueReq = "19";
  static const String fetchVersionOfADOfBarbecueRsp = "20";
  static const String fetchIdListOfADOfBarbecueReq = "21";
  static const String fetchIdListOfADOfBarbecueRsp = "22";
  static const String fetchRecordsOfADOfBarbecueReq = "23";
  static const String fetchRecordsOfADOfBarbecueRsp = "24";
  static const String fetchVersionOfADOfSnacksReq = "25";
  static const String fetchVersionOfADOfSnacksRsp = "26";
  static const String fetchIdListOfADOfSnacksReq = "27";
  static const String fetchIdListOfADOfSnacksRsp = "28";
  static const String fetchRecordsOfADOfSnacksReq = "29";
  static const String fetchRecordsOfADOfSnacksRsp = "30";

  String getName({required String minor}) {
    switch (minor) {
      case fetchVersionOfADOfCarouselReq:
        return 'fetchVersionOfADOfCarouselReq';
      case fetchVersionOfADOfCarouselRsp:
        return 'fetchVersionOfADOfCarouselRsp';
      case fetchIdListOfADOfCarouselReq:
        return 'fetchIdListOfADOfCarouselReq';
      case fetchIdListOfADOfCarouselRsp:
        return 'fetchIdListOfADOfCarouselRsp';
      case fetchRecordsOfADOfCarouselReq:
        return 'fetchRecordsOfADOfCarouselReq';
      case fetchRecordsOfADOfCarouselRsp:
        return 'fetchRecordsOfADOfCarouselRsp';
      case fetchVersionOfADOfDealsReq:
        return 'fetchVersionOfADOfDealsReq';
      case fetchVersionOfADOfDealsRsp:
        return 'fetchVersionOfADOfDealsRsp';
      case fetchIdListOfADOfDealsReq:
        return 'fetchIdListOfADOfDealsReq';
      case fetchIdListOfADOfDealsRsp:
        return 'fetchIdListOfADOfDealsRsp';
      case fetchRecordsOfADOfDealsReq:
        return 'fetchRecordsOfADOfDealsReq';
      case fetchRecordsOfADOfDealsRsp:
        return 'fetchRecordsOfADOfDealsRsp';
      case fetchVersionOfADOfHotsReq:
        return 'fetchVersionOfADOfHotsReq';
      case fetchVersionOfADOfHotsRsp:
        return 'fetchVersionOfADOfHotsRsp';
      case fetchIdListOfADOfHotsReq:
        return 'fetchIdListOfADOfHotsReq';
      case fetchIdListOfADOfHotsRsp:
        return 'fetchIdListOfADOfHotsRsp';
      case fetchRecordsOfADOfHotsReq:
        return 'fetchRecordsOfADOfHotsReq';
      case fetchRecordsOfADOfHotsRsp:
        return 'fetchRecordsOfADOfHotsRsp';
      case fetchVersionOfADOfBarbecueReq:
        return 'fetchVersionOfADOfBarbecueReq';
      case fetchVersionOfADOfBarbecueRsp:
        return 'fetchVersionOfADOfBarbecueRsp';
      case fetchIdListOfADOfBarbecueReq:
        return 'fetchIdListOfADOfBarbecueReq';
      case fetchIdListOfADOfBarbecueRsp:
        return 'fetchIdListOfADOfBarbecueRsp';
      case fetchRecordsOfADOfBarbecueReq:
        return 'fetchRecordsOfADOfBarbecueReq';
      case fetchRecordsOfADOfBarbecueRsp:
        return 'fetchRecordsOfADOfBarbecueRsp';
      case fetchVersionOfADOfSnacksReq:
        return 'fetchVersionOfADOfSnacksReq';
      case fetchVersionOfADOfSnacksRsp:
        return 'fetchVersionOfADOfSnacksRsp';
      case fetchIdListOfADOfSnacksReq:
        return 'fetchIdListOfADOfSnacksReq';
      case fetchIdListOfADOfSnacksRsp:
        return 'fetchIdListOfADOfSnacksRsp';
      case fetchRecordsOfADOfSnacksReq:
        return 'fetchRecordsOfADOfSnacksReq';
      case fetchRecordsOfADOfSnacksRsp:
        return 'fetchRecordsOfADOfSnacksRsp';
      default:
        return 'unknown';
    }
  }
}
