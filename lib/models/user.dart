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
  final String? promptpayId;
  final double? averageRating;
  final int? reviewCount;

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
    this.promptpayId,
    this.averageRating,
    this.reviewCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      firstName: json['firstName'] ?? json['first_name'],
      lastName: json['lastName'] ?? json['last_name'],
      nickname: json['nickname'] ?? json['user_nickname'] ?? json['Nickname'] ?? json['NickName'],
      phone: json['phone'] ?? json['phoneNumber'] ?? json['phone_number'] ?? json['user_phone'] ?? json['telephone'] ?? json['tel'] ?? json['mobile'] ?? json['Phone'] ?? json['PhoneNumber'],
      address: json['address'] ?? json['user_address'] ?? json['location'] ?? json['Address'],
      status: json['status'] ?? json['Status'] ?? 'active',
      profileImageUrl: json['profileImageUrl'] ?? json['profile_image_url'] ?? json['user_profile_image_url'] ?? json['avatar'] ?? json['image'] ?? json['ProfileImageUrl'],
      promptpayId: json['promptpayId'] ?? json['promptpay_id'] ?? json['user_promptpay_id'] ?? json['PromptpayId'],
      averageRating: json['averageRating'] != null ? double.tryParse(json['averageRating'].toString()) : (json['average_rating'] != null ? double.tryParse(json['average_rating'].toString()) : null),
      reviewCount: json['reviewCount'] != null ? int.tryParse(json['reviewCount'].toString()) : (json['review_count'] != null ? int.tryParse(json['review_count'].toString()) : null),
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
      'promptpayId': promptpayId,
    };
  }
}
