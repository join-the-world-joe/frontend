class ADOfDeals {
  String _title = '';
  int _stock = -1;
  int _sellingPrice = -1;
  int _productId = -1;
  String _productName = '';
  List<String> _sellingPoints = [];
  String _description = '';
  String _placeOfOrigin = '';
  int _advertisementId = -1;
  String _advertisementName = '';
  String _imagePath = '';

  ADOfDeals.construct({
    required String title,
    required int stock,
    required int sellingPrice,
    required int productId,
    required String productName,
    required List<String> sellingPoints,
    required String description,
    required String placeOfOrigin,
    required String imagePath,
    required int advertisementId,
    required String advertisementName,
  }) {
    _title = title;
    _stock = stock;
    _sellingPrice = sellingPrice;
    _productId = productId;
    _productName = productName;
    _sellingPoints = sellingPoints;
    _description = description;
    _placeOfOrigin = placeOfOrigin;
    _imagePath = imagePath;
    _advertisementId = advertisementId;
    _advertisementName = advertisementName;
  }

  String getTitle() {
    return _title;
  }

  int getStock() {
    return _stock;
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

  String getDescription() {
    return _description;
  }

  String getImagePath() {
    return _imagePath;
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
