import 'dart:convert';

class Room {
  final int availableCount;
  Room({required this.availableCount});
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      availableCount: json['availableCount'],
    );
  }
}

void main() {
  try {
    final jsonStr = '{"available_count": 5}';
    final json = jsonDecode(jsonStr);
    final room = Room.fromJson(json);
    print("Success: ${room.availableCount}");
  } catch (e) {
    print("Error: $e");
  }
}
