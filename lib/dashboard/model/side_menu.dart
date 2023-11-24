class SideMenu {
  final String _title;
  final List<String> _itemList;
  final List<String> _descList;

  String getTitle() {
    return _title;
  }

  List<String> getItemList() {
    return _itemList;
  }

  List<String> getDescList() {
    return _descList;
  }

  SideMenu(this._title, this._itemList, this._descList);
}
