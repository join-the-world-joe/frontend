class Menu {
  String _name = '';
  String _parent = '';
  String _description = '';

  Menu.construct({
    required String name,
    required String parent,
    required String description,
  }) {
    _name = name;
    _parent = parent;
    _description = description;
  }

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
