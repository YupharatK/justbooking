class RoomImage {
  final int id;
  final String url;

  RoomImage({required this.id, required this.url});

  factory RoomImage.fromJson(Map<String, dynamic> json) {
    return RoomImage(
      id: json['id'],
      url: json['url'],
    );
  }
}

class Room {
  final int id;
  final int dormitoryId;
  final String roomNumber;
  final String roomType;
  final double price;
  final int availableCount;
  final String status;
  final String? availableFrom;
  final List<String> facilities;
  final List<RoomImage>? images;

  Room({
    required this.id,
    required this.dormitoryId,
    required this.roomNumber,
    required this.roomType,
    required this.price,
    required this.availableCount,
    required this.status,
    this.availableFrom,
    required this.facilities,
    this.images,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      dormitoryId: json['dormitoryId'],
      roomNumber: json['roomNumber'],
      roomType: json['roomType'],
      price: (json['price'] as num).toDouble(),
      availableCount: json['availableCount'],
      status: json['status'],
      availableFrom: json['availableFrom'],
      facilities: List<String>.from(json['facilities'] ?? []),
      images: json['images'] != null 
          ? (json['images'] as List).map((i) => RoomImage.fromJson(i)).toList() 
          : null,
    );
  }
}
