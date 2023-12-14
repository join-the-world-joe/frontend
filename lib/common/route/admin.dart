class Admin {
  static const String signInReq = '1';
  static const String signInRsp = '2';
  static const String fetchMenuListOfConditionReq = '3';
  static const String fetchMenuListOfConditionRsp = '4';
  static const String fetchUserListOfConditionReq = '5';
  static const String fetchUserListOfConditionRsp = '6';
  static const String fetchRoleListOfConditionReq = '7';
  static const String fetchRoleListOfConditionRsp = '8';
  static const String fetchPermissionListOfConditionReq = '9';
  static const String fetchPermissionListOfConditionRsp = '10';
  static const String insertUserRecordReq = '11';
  static const String insertUserRecordRsp = '12';
  static const String softDeleteUserRecordReq = '13';
  static const String softDeleteUserRecordRsp = '14';
  static const String updateUserRecordReq = '15';
  static const String updateUserRecordRsp = '16';
  static const String fetchFieldListOfConditionReq = "17";
  static const String fetchFieldListOfConditionRsp = "18";
  static const String fetchTrackListOfConditionReq = "19";
  static const String fetchTrackListOfConditionRsp = "20";
  static const String checkPermissionReq = "21";
  static const String checkPermissionRsp = "22";
  static const String fetchIdListOfGoodReq = "23";
  static const String fetchIdListOfGoodRsp = "24";
  static const String fetchRecordsOfGoodReq = "25";
  static const String fetchRecordsOfGoodRsp = "26";
  static const String insertRecordOfGoodReq = "27";
  static const String insertRecordOfGoodRsp = "28";
  static const String softDeleteRecordsOfGoodReq = "29";
  static const String softDeleteRecordsOfGoodRsp = "30";
  static const String updateRecordOfGoodReq = "31";
  static const String updateRecordOfGoodRsp = "32";
  static const String fetchIdListOfAdvertisementReq = "33";
  static const String fetchIdListOfAdvertisementRsp = "34";
  static const String fetchRecordsOfAdvertisementReq = "35";
  static const String fetchRecordsOfAdvertisementRsp = "36";
  static const String insertRecordOfAdvertisementReq = "37";
  static const String insertRecordOfAdvertisementRsp = "38";
  static const String softDeleteRecordsOfAdvertisementReq = "39";
  static const String softDeleteRecordsOfAdvertisementRsp = "40";
  static const String updateRecordOfAdvertisementReq = "41";
  static const String updateRecordOfAdvertisementRsp = "42";
  static const String insertRecordOfADOfCarouselReq = "43";
  static const String insertRecordOfADOfCarouselRsp = "44";
  static const String removeOutdatedRecordsOfADOfCarouselReq = "45";
  static const String removeOutdatedRecordsOfADOfCarouselRsp = "46";
  static const String insertRecordOfADOfDealsReq = "47";
  static const String insertRecordOfADOfDealsRsp = "48";
  static const String removeOutdatedRecordsOfADOfDealsReq = "49";
  static const String removeOutdatedRecordsOfADOfDealsRsp = "50";
  static const String insertRecordOfADOfHotsReq = "51";
  static const String insertRecordOfADOfHotsRsp = "52";
  static const String removeOutdatedRecordsOfADOfHotsReq = "53";
  static const String removeOutdatedRecordsOfADOfHotsRsp = "54";
  static const String insertRecordOfADOfBarbecueReq = "55";
  static const String insertRecordOfADOfBarbecueRsp = "56";
  static const String removeOutdatedRecordsOfADOfBarbecueReq = "57";
  static const String removeOutdatedRecordsOfADOfBarbecueRsp = "58";
  static const String insertRecordOfADOfSnacksReq = "59";
  static const String insertRecordOfADOfSnacksRsp = "60";
  static const String removeOutdatedRecordsOfADOfSnacksReq = "61";
  static const String removeOutdatedRecordsOfADOfSnacksRsp = "62";

  String getName({required String minor}) {
    switch (minor) {
      case signInReq:
        return 'signInReq';
      case signInRsp:
        return 'signInRsp';
      case fetchMenuListOfConditionReq:
        return 'fetchMenuListOfConditionReq';
      case fetchMenuListOfConditionRsp:
        return 'fetchMenuListOfConditionRsp';
      case fetchUserListOfConditionReq:
        return 'fetchUserListOfConditionReq';
      case fetchUserListOfConditionRsp:
        return 'fetchUserListOfConditionRsp';
      case fetchRoleListOfConditionReq:
        return 'fetchRoleListOfConditionReq';
      case fetchRoleListOfConditionRsp:
        return 'fetchRoleListOfConditionRsp';
      case fetchPermissionListOfConditionReq:
        return 'fetchPermissionListOfConditionReq';
      case fetchPermissionListOfConditionRsp:
        return 'fetchPermissionListOfConditionRsp';
      case insertUserRecordReq:
        return 'insertUserRecordReq';
      case insertUserRecordRsp:
        return 'insertUserRecordRsp';
      case softDeleteUserRecordReq:
        return 'softDeleteUserRecordReq';
      case softDeleteUserRecordRsp:
        return 'softDeleteUserRecordRsp';
      case updateUserRecordReq:
        return 'updateUserRecordReq';
      case updateUserRecordRsp:
        return 'updateUserRecordRsp';
      case fetchFieldListOfConditionReq:
        return 'fetchFieldListOfConditionReq';
      case fetchFieldListOfConditionRsp:
        return fetchFieldListOfConditionRsp;
      case fetchTrackListOfConditionReq:
        return 'fetchTrackListOfConditionReq';
      case fetchTrackListOfConditionRsp:
        return 'fetchTrackListOfConditionRsp';
      case checkPermissionReq:
        return 'checkPermissionReq';
      case checkPermissionRsp:
        return 'checkPermissionRsp';
      case fetchIdListOfGoodReq:
        return 'fetchIdListOfGoodReq';
      case fetchIdListOfGoodRsp:
        return 'fetchIdListOfGoodRsp';
      case fetchRecordsOfGoodReq:
        return 'fetchRecordsOfGoodReq';
      case fetchRecordsOfGoodRsp:
        return 'fetchRecordsOfGoodRsp';
      case insertRecordOfGoodReq:
        return 'insertRecordOfGoodReq';
      case insertRecordOfGoodRsp:
        return 'insertRecordOfGoodRsp';
      case softDeleteRecordsOfGoodReq:
        return 'softDeleteRecordsOfGoodReq';
      case softDeleteRecordsOfGoodRsp:
        return 'softDeleteRecordsOfGoodRsp';
      case updateRecordOfGoodReq:
        return 'updateRecordOfGoodReq';
      case updateRecordOfGoodRsp:
        return 'updateRecordOfGoodRsp';
      case fetchIdListOfAdvertisementReq:
        return 'fetchIdListOfAdvertisementReq';
      case fetchIdListOfAdvertisementRsp:
        return 'fetchIdListOfAdvertisementRsp';
      case fetchRecordsOfAdvertisementReq:
        return 'fetchRecordsOfAdvertisementReq';
      case fetchRecordsOfAdvertisementRsp:
        return 'fetchRecordsOfAdvertisementRsp';
      case insertRecordOfAdvertisementReq:
        return 'insertRecordOfAdvertisementReq';
      case insertRecordOfAdvertisementRsp:
        return 'insertRecordOfAdvertisementRsp';
      case softDeleteRecordsOfAdvertisementReq:
        return 'softDeleteRecordsOfAdvertisementReq';
      case softDeleteRecordsOfAdvertisementRsp:
        return 'softDeleteRecordsOfAdvertisementRsp';
      case updateRecordOfAdvertisementReq:
        return 'updateRecordOfAdvertisementReq';
      case updateRecordOfAdvertisementRsp:
        return 'updateRecordOfAdvertisementRsp';
      case insertRecordOfADOfCarouselReq:
        return 'insertRecordOfADOfCarouselReq';
      case insertRecordOfADOfCarouselRsp:
        return 'insertRecordOfADOfCarouselRsp';
      case removeOutdatedRecordsOfADOfCarouselReq:
        return 'removeOutdatedRecordsOfADOfCarouselReq';
      case removeOutdatedRecordsOfADOfCarouselRsp:
        return 'removeOutdatedRecordsOfADOfCarouselRsp';
      case insertRecordOfADOfDealsReq:
        return 'insertRecordOfADOfDealsReq';
      case insertRecordOfADOfDealsRsp:
        return 'insertRecordOfADOfDealsRsp';
      case removeOutdatedRecordsOfADOfDealsReq:
        return 'removeOutdatedRecordsOfADOfDealsReq';
      case removeOutdatedRecordsOfADOfDealsRsp:
        return 'removeOutdatedRecordsOfADOfDealsRsp';
      case insertRecordOfADOfHotsReq:
        return 'insertRecordOfADOfHotsReq';
      case insertRecordOfADOfHotsRsp:
        return 'insertRecordOfADOfHotsRsp';
      case removeOutdatedRecordsOfADOfHotsReq:
        return 'removeOutdatedRecordsOfADOfHotsReq';
      case removeOutdatedRecordsOfADOfHotsRsp:
        return 'removeOutdatedRecordsOfADOfHotsRsp';
      case insertRecordOfADOfBarbecueReq:
        return 'insertRecordOfADOfBarbecueReq';
      case insertRecordOfADOfBarbecueRsp:
        return 'insertRecordOfADOfBarbecueRsp';
      case removeOutdatedRecordsOfADOfBarbecueReq:
        return 'removeOutdatedRecordsOfADOfBarbecueReq';
      case removeOutdatedRecordsOfADOfBarbecueRsp:
        return 'removeOutdatedRecordsOfADOfBarbecueRsp';
      case insertRecordOfADOfSnacksReq:
        return 'insertRecordOfADOfSnacksReq';
      case insertRecordOfADOfSnacksRsp:
        return 'insertRecordOfADOfSnacksRsp';
      case removeOutdatedRecordsOfADOfSnacksReq:
        return 'removeOutdatedRecordsOfADOfSnacksReq';
      case removeOutdatedRecordsOfADOfSnacksRsp:
        return 'removeOutdatedRecordsOfADOfSnacksRsp';
      default:
        return 'unknown';
    }
  }
}
