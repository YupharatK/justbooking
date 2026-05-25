import 'dormitory.dart';
import 'room.dart';
import 'user.dart';

class Booking {
  final int id;
  final int userId;
  final int roomId;
  final String moveInDate;
  final String? note;
  final String status;
  final String paymentStatus;
  final String? qrCodeUrl;
  final String? paymentSlipUrl;
  final String createdAt;
  
  // Relations
  final User? user;
  final Room? room;
  final Dormitory? dormitory; // Usually from joining through room

  Booking({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.moveInDate,
    this.note,
    required this.status,
    required this.paymentStatus,
    this.qrCodeUrl,
    this.paymentSlipUrl,
    required this.createdAt,
    this.user,
    this.room,
    this.dormitory,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? json['bookingId'],
      userId: json['userId'],
      roomId: json['roomId'],
      moveInDate: json['moveInDate'],
      note: json['note'],
      status: json['status'] ?? 'pending',
      paymentStatus: json['paymentStatus'] ?? json['payment_status'] ?? 'pending',
      qrCodeUrl: json['qrCodeUrl'] ?? json['qr_code_url'],
      paymentSlipUrl: json['paymentSlipUrl'] ?? json['payment_slip_url'],
      createdAt: json['createdAt'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
      dormitory: json['dormitory'] != null ? Dormitory.fromJson(json['dormitory']) : null,
    );
  }
}
