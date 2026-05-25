class User {
  final int id;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;
  final String? nickname;
  final String? phone;
  final String? address;
  final String status;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.nickname,
    this.phone,
    this.address,
    required this.status,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'] ?? json['first_name'],
      lastName: json['lastName'] ?? json['last_name'],
      nickname: json['nickname'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'] ?? 'active',
      profileImageUrl: json['profileImageUrl'] ?? json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'phone': phone,
      'address': address,
      'status': status,
    };
  }
}
