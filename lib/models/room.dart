class RoomImage {
  final int id;
  final String url;

  RoomImage({required this.id, required this.url});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'] ?? 0,
      url: json['url'] ?? json['image_url'] ?? '',
    );
  }
}

class Room {
  final int id;
  final int dormitoryId;
  final String roomNumber;
  final String roomType;
  final double price;
  final double securityDeposit;
  final int availableCount;
  final String status;
  final DateTime? availableFrom;
  final List<String> facilities;
  final List<RoomImage>? images;

  double get bookingFee => securityDeposit / 2;

  Room({
    required this.id,
    required this.dormitoryId,
    required this.roomNumber,
    required this.roomType,
    required this.price,
    required this.securityDeposit,
    required this.availableCount,
    required this.status,
    this.availableFrom,
    required this.facilities,
    this.images,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    final parsedPrice = double.tryParse(json['price']?.toString() ?? '0') ?? 0.0;
    
    // Fallback: If security_deposit is not provided by backend, use price as security deposit
    final parsedSecurityDeposit = double.tryParse(json['security_deposit']?.toString() ?? '') ?? parsedPrice;

    DateTime? parsedAvailableFrom;
    final availableFromStr = json['availableFrom'] ?? json['available_from'];
    if (availableFromStr != null) {
      parsedAvailableFrom = DateTime.tryParse(availableFromStr.toString());
    }

    return Room(
      id: json['id'] ?? 0,
      dormitoryId: json['dormitoryId'] ?? json['dormitory_id'] ?? 0,
      roomNumber: json['roomNumber'] ?? json['room_number'] ?? '',
      roomType: json['roomType'] ?? json['room_type'] ?? '',
      price: parsedPrice,
      securityDeposit: parsedSecurityDeposit,
      availableCount: json['availableCount'] ?? json['available_count'] ?? 0,
      status: json['status'] ?? 'available',
      availableFrom: parsedAvailableFrom,
      facilities: List<String>.from(json['facilities'] ?? []),
      images: json['images'] != null 
          ? (json['images'] as List).map((i) => RoomImage.fromJson(i)).toList() 
          : null,
    );
  }
}
