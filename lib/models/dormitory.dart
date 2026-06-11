import 'room.dart';
import 'review.dart';

class Dormitory {
  final int id;
  final int? ownerId;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceFromUniversityKm;
  final List<String> facilities;
  final List<String> securityFeatures;
  final String rentalTerms;
  final String rules;
  final String status;
  final String? coverImageUrl;
  final double? rating;
  final List<Room>? rooms;
  final List<Review>? reviews;

  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final String? promptPayNumber;
  final String? promptPayQrImage;

  Dormitory({
    required this.id,
    this.ownerId,
    required this.name,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceFromUniversityKm,
    required this.facilities,
    required this.securityFeatures,
    required this.rentalTerms,
    required this.rules,
    required this.status,
    this.coverImageUrl,
    this.rating,
    this.rooms,
    this.reviews,
    this.bankName,
    this.accountName,
    this.accountNumber,
    this.promptPayNumber,
    this.promptPayQrImage,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory Dormitory.fromJson(Map<String, dynamic> json) {
    return Dormitory(
      id: json['id'] ?? 0,
      ownerId: json['owner_id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      distanceFromUniversityKm: _parseDouble(json['distance_from_university_km']),
      facilities: json['facilities'] != null ? List<String>.from(json['facilities']) : [],
      securityFeatures: json['security_features'] != null ? List<String>.from(json['security_features']) : [],
      rentalTerms: json['rental_terms'] ?? '',
      rules: json['rules'] ?? '',
      status: json['status'] ?? 'pending',
      coverImageUrl: json['cover_image_url'],
      rating: json['rating'] != null ? _parseDouble(json['rating']) : null,
      rooms: json['rooms'] != null 
          ? (json['rooms'] as List).map((i) => Room.fromJson(i)).toList() 
          : null,
      reviews: json['reviews'] != null 
          ? (json['reviews'] as List).map((i) => Review.fromJson(i)).toList() 
          : null,
      bankName: json['bank_name'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      promptPayNumber: json['promptpay_number'],
      promptPayQrImage: json['promptpay_qr_image'],
    );
  }
}
