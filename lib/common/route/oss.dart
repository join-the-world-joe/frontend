class OSS {
  static const String fetchHeaderListOfObjectFileListOfAdvertisementReq = '1';
  static const String fetchHeaderListOfObjectFileListOfAdvertisementRsp = '2';
  static const verifyObjectFileListOfAdvertisementReq = "3";
  static const verifyObjectFileListOfAdvertisementRsp = "4";

  String getName({required String minor}) {
    switch (minor) {
      case fetchHeaderListOfObjectFileListOfAdvertisementReq:
        return 'fetchHeaderListOfObjectFileListOfAdvertisementReq';
      case fetchHeaderListOfObjectFileListOfAdvertisementRsp:
        return 'fetchHeaderListOfObjectFileListOfAdvertisementRsp';
      case verifyObjectFileListOfAdvertisementReq:
        return 'verifyObjectFileListOfAdvertisementReq';
      case verifyObjectFileListOfAdvertisementRsp:
        return 'verifyObjectFileListOfAdvertisementRsp';
      default:
        return 'unknown';
    }
  }
}
