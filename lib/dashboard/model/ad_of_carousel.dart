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
  String _image = '';
  int _status = -1;

  ADOfCarousel.construct({
    required String title,
    required int stock,
    required int status,
    required int sellingPrice,
    required int productId,
    required String productName,
    required List<String> sellingPoints,
    required String placeOfOrigin,
    required String image,
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
    _image = image;
    _advertisementId = advertisementId;
    _advertisementName = advertisementName;
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

  String getImage() {
    return _image;
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
