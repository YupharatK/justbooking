import 'room.dart';
import 'review.dart';

class Dormitory {
  final int id;
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

  Dormitory({
    required this.id,
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
  });

  factory Dormitory.fromJson(Map<String, dynamic> json) {
    return Dormitory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : 0.0,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : 0.0,
      distanceFromUniversityKm: json['distance_from_university_km'] != null ? (json['distance_from_university_km'] as num).toDouble() : 0.0,
      facilities: json['facilities'] != null ? List<String>.from(json['facilities']) : [],
      securityFeatures: json['security_features'] != null ? List<String>.from(json['security_features']) : [],
      rentalTerms: json['rental_terms'] ?? '',
      rules: json['rules'] ?? '',
      status: json['status'] ?? 'pending',
      coverImageUrl: json['cover_image_url'],
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      rooms: json['rooms'] != null 
          ? (json['rooms'] as List).map((i) => Room.fromJson(i)).toList() 
          : null,
      reviews: json['reviews'] != null 
          ? (json['reviews'] as List).map((i) => Review.fromJson(i)).toList() 
          : null,
    );
  }
}
