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
  final String updatedAt;
  
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
    required this.updatedAt,
    this.user,
    this.room,
    this.dormitory,
  });


  factory Booking.fromJson(Map<String, dynamic> json) {
    // Handle flat room data from the API
    Room? parsedRoom;
    if (json['room'] != null) {
      parsedRoom = Room.fromJson(json['room']);
    } else if (json['room_number'] != null || json['room_type'] != null) {
      parsedRoom = Room(
        id: json['roomId'] ?? json['room_id'] ?? 0,
        dormitoryId: 0,
        roomNumber: json['roomNumber'] ?? json['room_number'] ?? '',
        roomType: json['roomType'] ?? json['room_type'] ?? '',
        price: double.tryParse(json['totalAmount']?.toString() ?? json['total_amount']?.toString() ?? '0') ?? 0.0,
        securityDeposit: double.tryParse(json['totalAmount']?.toString() ?? json['total_amount']?.toString() ?? '0') ?? 0.0,
        availableCount: 0,
        status: '',
        facilities: [],
      );
    }

    // Handle flat dormitory data from the API
    Dormitory? parsedDormitory;
    if (json['dormitory'] != null) {
      parsedDormitory = Dormitory.fromJson(json['dormitory']);
    } else if (json['dormitory_name'] != null) {
      parsedDormitory = Dormitory(
        id: 0,
        name: json['dormitoryName'] ?? json['dormitory_name'] ?? '',
        description: '',
        address: '',
        latitude: 0,
        longitude: 0,
        distanceFromUniversityKm: 0,
        facilities: [],
        securityFeatures: [],
        rentalTerms: '',
        rules: '',
        status: '',
      );
    }

    User? parsedUser;
    final userJson = json['user'] ?? json['User'] ?? json['tenant'] ?? json['customer'];
    if (userJson != null && userJson is Map<String, dynamic>) {
      parsedUser = User.fromJson(userJson);
    } else if (json['first_name'] != null || json['firstName'] != null || json['FirstName'] != null) {
      parsedUser = User(
        id: json['userId'] ?? json['user_id'] ?? json['UserId'] ?? 0,
        email: json['email'] ?? json['user_email'] ?? json['userEmail'] ?? json['Email'] ?? '',
        role: 'user',
        firstName: json['firstName'] ?? json['first_name'] ?? json['user_first_name'] ?? json['userFirstName'] ?? json['FirstName'],
        lastName: json['lastName'] ?? json['last_name'] ?? json['user_last_name'] ?? json['userLastName'] ?? json['LastName'],
        nickname: json['nickname'] ?? json['user_nickname'] ?? json['userNickname'] ?? json['Nickname'] ?? json['NickName'],
        phone: json['phone'] ?? json['user_phone'] ?? json['userPhone'] ?? json['phoneNumber'] ?? json['phone_number'] ?? json['telephone'] ?? json['tel'] ?? json['mobile'] ?? json['Phone'] ?? json['PhoneNumber'],
        address: json['address'] ?? json['user_address'] ?? json['userAddress'] ?? json['location'] ?? json['Address'],
        status: 'active',
        profileImageUrl: json['profileImageUrl'] ?? json['profile_image_url'] ?? json['user_profile_image_url'] ?? json['userProfileImageUrl'] ?? json['avatar'] ?? json['image'] ?? json['ProfileImageUrl'],
        promptpayId: json['promptpayId'] ?? json['promptpay_id'] ?? json['user_promptpay_id'] ?? json['userPromptpayId'] ?? json['PromptpayId'],
      );
    }

    return Booking(
      id: json['id'] ?? json['bookingId'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      roomId: json['roomId'] ?? json['room_id'] ?? 0,
      moveInDate: json['moveInDate'] ?? json['move_in_date'] ?? '',
      note: json['note'],
      status: json['status'] ?? 'pending',
      paymentStatus: json['paymentStatus'] ?? json['payment_status'] ?? 'pending',
      qrCodeUrl: json['qrCodeUrl'] ?? json['qr_code_url'],
      paymentSlipUrl: json['paymentSlipUrl'] ?? json['payment_slip_url'] ?? json['slip_image_url'] ?? json['slipImageUrl'],
      createdAt: json['createdAt'] ?? json['created_at'] ?? '',
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? json['createdAt'] ?? json['created_at'] ?? '',
      user: parsedUser,
      room: parsedRoom,
      dormitory: parsedDormitory,
    );
  }
}
