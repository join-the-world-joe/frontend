class Menu {
  final String _title;
  final List<String> _itemList;

  String getTitle() {
    return _title;
  }

  List<String> getItemList() {
    return _itemList;
  }

  Menu(this._title, this._itemList);
}
