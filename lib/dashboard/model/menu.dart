class Menu {
  final String _name;
  final String _parent;
  final String _description;

  Menu(this._name, this._parent, this._description);

  String getName() {
    return _name;
  }

  String getParent() {
    return _parent;
  }

  String getDescription() {
    return _description;
  }
}
