class User {
  String id;
  String name;
  String account;
  String email;
  String department;
  String countryCode;
  String phoneNumber;
  String status;
  String createdAt;

  User({
    required this.id,
    required this.name,
    required this.account,
    required this.email,
    required this.department,
    required this.countryCode,
    required this.phoneNumber,
    required this.status,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String id = 'null',
        name = 'null',
        account = 'null',
        email = 'null',
        department = 'null',
        countryCode = 'null',
        phoneNumber = 'null',
        status = 'null',
        createdAt = 'null';
    try {
      id = json['id'] ?? 'Empty';
      name = json['name'] ?? 'Empty';
      account = json['account'] ?? 'Empty';
      email = json['email'] ?? 'Empty';
      department = json['department'] ?? 'Empty';
      countryCode = json['country_code'] ?? 'Empty';
      phoneNumber = json['phone_number'] ?? 'Empty';
      status = json['status'] ?? 'Empty';
      createdAt = json['created_at'] ?? 'Empty';
    } catch (e) {
      print('e: $e');
    }
    return User(
      id: id,
      name: name,
      account: account,
      email: email,
      department: department,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      status: status,
      createdAt: createdAt,
    );
  }
}
