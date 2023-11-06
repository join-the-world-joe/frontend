class Role {
  String name;
  String description;

  Role({required this.name, required this.description});

  factory Role.fromJson(Map<String, dynamic> json) {
    String name = 'null', description = 'null';
    try {
      name = json['name'] ?? 'Empty';
      description = json['description'] ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return Role(
      name: name,
      description: description,
    );
  }
}
