import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_booking/models/user.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a consistent chat ID based on dorm ID and user ID
  String getChatId(int dormId, int userId) {
    return 'dorm_${dormId}_user_$userId';
  }

  // Get stream of messages for a specific chat
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList());
  }

  // Send a message
    // ฟังก์ชันสำหรับส่งข้อความแชทไปหาเจ้าของหอพักหรือผู้เช่า
  Future<void> sendMessage(String chatId, int dormId, User currentUser, String text, {String? dormName}) async {
    final messageRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final batch = _firestore.batch();

    // 1. Save the message
    batch.set(messageRef, {
      'senderId': currentUser.id.toString(),
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. Update the chat metadata
    final chatRef = _firestore.collection('chats').doc(chatId);
    batch.set(chatRef, {
      'dormId': dormId.toString(),
      'userId': currentUser.id.toString(),
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'userName': '${currentUser.firstName ?? ''} ${currentUser.lastName ?? ''}'.trim(),
      'dormName': dormName ?? 'Dormitory $dormId',
    }, SetOptions(merge: true));

    await batch.commit();
  }

  // Get stream of chats for a specific user
  Stream<QuerySnapshot> getUserChats(int userId) {
    return _firestore
        .collection('chats')
        .where('userId', isEqualTo: userId.toString())
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get stream of chats for a specific dorm (for the owner)
  Stream<QuerySnapshot> getDormChats(int dormId) {
    return _firestore
        .collection('chats')
        .where('dormId', isEqualTo: dormId.toString())
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Mark messages as read (optional enhancement)
    // ฟังก์ชันสำหรับทำเครื่องหมายว่าอ่านข้อความในแชทแล้ว
  Future<void> markAsRead(String chatId) async {
    // implementation
  }
}
