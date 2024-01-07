class ADOfCarousel {
  String _title = '';
  int _stock = -1;
  int _sellingPrice = -1;
  int _productId = -1;
  String _productName = '';
  List<String> _sellingPoints = [];
  String _placeOfOrigin = '';
  int _advertisementId = -1;
  String _advertisementName = '';
  int _status = -1;
  String _coverImage = '';
  String _firstImage = '';
  String _secondImage = '';
  String _thirdImage = '';
  String _fourthImage = '';
  String _fifthImage = '';
  String _ossPath = '';

  ADOfCarousel.construct({
    required String title,
    required int stock,
    required int status,
    required String ossPath,
    required int sellingPrice,
    required int productId,
    required String productName,
    required List<String> sellingPoints,
    required String placeOfOrigin,
    required String coverImage,
    required String firstImage,
    required String secondImage,
    required String thirdImage,
    required String fourthImage,
    required String fifthImage,
    required int advertisementId,
    required String advertisementName,
  }) {
    _title = title;
    _stock = stock;
    _status = status;
    _sellingPrice = sellingPrice;
    _productId = productId;
    _productName = productName;
    _sellingPoints = sellingPoints;
    _placeOfOrigin = placeOfOrigin;
    _advertisementId = advertisementId;
    _advertisementName = advertisementName;

    _coverImage = coverImage;
    _firstImage = firstImage;
    _secondImage = secondImage;
    _thirdImage = thirdImage;
    _fourthImage = fourthImage;
    _fifthImage = fifthImage;
    _ossPath = ossPath;
  }

  String getTitle() {
    return _title;
  }

  int getStock() {
    return _stock;
  }

  int getStatus() {
    return _status;
  }

  int getSellingPrice() {
    return _sellingPrice;
  }

  int getProductId() {
    return _productId;
  }

  String getProductName() {
    return _productName;
  }

  String getOSSPath() {
    return _ossPath;
  }

  String getCoverImage() {
    return _coverImage;
  }

  String getFirstImage() {
    return _firstImage;
  }

  String getSecondImage() {
    return _secondImage;
  }

  String getThirdImage() {
    return _thirdImage;
  }

  String getFourthImage() {
    return _fourthImage;
  }

  String getFifthImage() {
    return _fifthImage;
  }

  List<String> getSellingPoints() {
    return _sellingPoints;
  }

  String getPlaceOfOrigin() {
    return _placeOfOrigin;
  }

  int getAdvertisementId() {
    return _advertisementId;
  }

  String getAdvertisementName() {
    return _advertisementName;
  }
}
