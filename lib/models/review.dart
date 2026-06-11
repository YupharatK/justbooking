import 'user.dart';

class Review {
  final int id;
  final int dormitoryId;
  final int userId;
  final double rating;
  final String comment;
  final String? ownerReply;
  final String status;
  final String createdAt;
  final User? user;

  Review({
    required this.id,
    required this.dormitoryId,
    required this.userId,
    required this.rating,
    required this.comment,
    this.ownerReply,
    required this.status,
    required this.createdAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      dormitoryId: json['dormitoryId'] ?? json['dormitory_id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] ?? '',
      ownerReply: json['ownerReply'] ?? json['owner_reply'],
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] ?? json['created_at'] ?? '',
      user: json['user'] != null 
          ? User.fromJson(json['user']) 
          : (json['first_name'] != null || json['nickname'] != null)
              ? User(
                  id: json['userId'] ?? json['user_id'] ?? 0,
                  email: '',
                  role: 'user',
                  firstName: json['firstName'] ?? json['first_name'],
                  lastName: json['lastName'] ?? json['last_name'],
                  nickname: json['nickname'],
                  status: 'active',
                )
              : null,
    );
  }
}
