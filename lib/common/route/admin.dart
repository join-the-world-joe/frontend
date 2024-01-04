class Admin {
  static const String signInReq = "1";
  static const String signInRsp = "2";
  static const String fetchMenuListOfConditionReq = "3";
  static const String fetchMenuListOfConditionRsp = "4";
  static const String fetchUserListOfConditionReq = "5";
  static const String fetchUserListOfConditionRsp = "6";
  static const String fetchRoleListOfConditionReq = "7";
  static const String fetchRoleListOfConditionRsp = "8";
  static const String fetchPermissionListOfConditionReq = "9";
  static const String fetchPermissionListOfConditionRsp = "10";
  static const String insertRecordOfUserReq = "11";
  static const String insertRecordOfUserRsp = "12";
  static const String softDeleteRecordOfUserReq = "13";
  static const String softDeleteRecordOfUserRsp = "14";
  static const String updateRecordOfUserReq = "15";
  static const String updateRecordOfUserRsp = "16";
  static const String fetchFieldListOfConditionReq = "17";
  static const String fetchFieldListOfConditionRsp = "18";
  static const String fetchTrackListOfConditionReq = "19";
  static const String fetchTrackListOfConditionRsp = "20";
  static const String checkPermissionReq = "21";
  static const String checkPermissionRsp = "22";
  static const String insertRecordOfProductReq = "23";
  static const String insertRecordOfProductRsp = "24";
  static const String softDeleteRecordsOfProductReq = "25";
  static const String softDeleteRecordsOfProductRsp = "26";
  static const String updateRecordOfProductReq = "27";
  static const String updateRecordOfProductRsp = "28";
  static const String insertRecordOfAdvertisementReq = "29";
  static const String insertRecordOfAdvertisementRsp = "30";
  static const String softDeleteRecordsOfAdvertisementReq = "31";
  static const String softDeleteRecordsOfAdvertisementRsp = "32";
  static const String updateRecordOfAdvertisementReq = "33";
  static const String updateRecordOfAdvertisementRsp = "34";
  static const String insertRecordOfADOfCarouselReq = "35";
  static const String insertRecordOfADOfCarouselRsp = "36";
  static const String removeOutdatedRecordsOfADOfCarouselReq = "37";
  static const String removeOutdatedRecordsOfADOfCarouselRsp = "38";
  static const String insertRecordOfADOfDealsReq = "39";
  static const String insertRecordOfADOfDealsRsp = "40";
  static const String removeOutdatedRecordsOfADOfDealsReq = "41";
  static const String removeOutdatedRecordsOfADOfDealsRsp = "42";
  static const String insertRecordOfADOfCampingReq = "43";
  static const String insertRecordOfADOfCampingRsp = "44";
  static const String removeOutdatedRecordsOfADOfCampingReq = "45";
  static const String removeOutdatedRecordsOfADOfCampingRsp = "46";
  static const String insertRecordOfADOfBarbecueReq = "47";
  static const String insertRecordOfADOfBarbecueRsp = "48";
  static const String removeOutdatedRecordsOfADOfBarbecueReq = "49";
  static const String removeOutdatedRecordsOfADOfBarbecueRsp = "50";
  static const String insertRecordOfADOfSnacksReq = "51";
  static const String insertRecordOfADOfSnacksRsp = "52";
  static const String removeOutdatedRecordsOfADOfSnacksReq = "53";
  static const String removeOutdatedRecordsOfADOfSnacksRsp = "54";

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
      case insertRecordOfUserReq:
        return 'insertRecordOfUserReq';
      case insertRecordOfUserRsp:
        return 'insertRecordOfUserRsp';
      case softDeleteRecordOfUserReq:
        return 'softDeleteRecordOfUserReq';
      case softDeleteRecordOfUserRsp:
        return 'softDeleteRecordOfUserRsp';
      case updateRecordOfUserReq:
        return 'updateRecordOfUserReq';
      case updateRecordOfUserRsp:
        return 'updateRecordOfUserRsp';
      case fetchFieldListOfConditionReq:
        return 'fetchFieldListOfConditionReq';
      case fetchFieldListOfConditionRsp:
        return 'fetchFieldListOfConditionRsp';
      case fetchTrackListOfConditionReq:
        return 'fetchTrackListOfConditionReq';
      case fetchTrackListOfConditionRsp:
        return 'fetchTrackListOfConditionRsp';
      case checkPermissionReq:
        return 'checkPermissionReq';
      case checkPermissionRsp:
        return 'checkPermissionRsp';
      case insertRecordOfProductReq:
        return 'insertRecordOfProductReq';
      case insertRecordOfProductRsp:
        return 'insertRecordOfProductRsp';
      case softDeleteRecordsOfProductReq:
        return 'softDeleteRecordsOfProductReq';
      case softDeleteRecordsOfProductRsp:
        return 'softDeleteRecordsOfProductRsp';
      case updateRecordOfProductReq:
        return 'updateRecordOfProductReq';
      case updateRecordOfProductRsp:
        return 'updateRecordOfProductRsp';
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
      case insertRecordOfADOfCampingReq:
        return 'insertRecordOfADOfCampingReq';
      case insertRecordOfADOfCampingRsp:
        return 'insertRecordOfADOfCampingRsp';
      case removeOutdatedRecordsOfADOfCampingReq:
        return 'removeOutdatedRecordsOfADOfCampingReq';
      case removeOutdatedRecordsOfADOfCampingRsp:
        return 'removeOutdatedRecordsOfADOfCampingRsp';
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
