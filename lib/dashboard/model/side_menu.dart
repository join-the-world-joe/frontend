class SideMenu {
  String _title = '';
  List<String> _itemList = [];
  List<String> _descList = [];

  String getTitle() {
    return _title;
  }

  List<String> getItemList() {
    return _itemList;
  }

  List<String> getDescList() {
    return _descList;
  }

  // SideMenu(this._title, this._itemList, this._descList);
  SideMenu.construct({
    required String title,
    required List<String> itemList,
    required List<String> descList,
  }) {
    _title = title;
    _itemList = itemList;
    _descList = descList;
  }
}
