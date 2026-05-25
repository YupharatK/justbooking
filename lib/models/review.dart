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
      id: json['id'],
      dormitoryId: json['dormitoryId'],
      userId: json['userId'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      ownerReply: json['ownerReply'],
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
