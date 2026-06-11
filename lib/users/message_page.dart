import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:just_booking/services/chat_service.dart';
import 'package:just_booking/services/auth_service.dart';
import 'package:just_booking/models/user.dart';
import 'package:just_booking/users/chat_screen.dart';

/// หน้าจอรวมรายการห้องแชททั้งหมดของผู้ใช้งาน

class MessagePage extends StatefulWidget {
  final VoidCallback? onBack;
  const MessagePage({super.key, this.onBack});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  @override
    // ฟังก์ชัน initState จะถูกเรียกใช้งานเป็นสิ่งแรกสุดเมื่อเปิดหน้านี้ขึ้นมา (มักใช้สำหรับดึงข้อมูลเตรียมไว้)
void initState() {
    super.initState();
    _loadUser();
  }

    // ฟังก์ชันแบบ Asynchronous สำหรับติดต่อระบบหลังบ้าน (Backend) หรือประมวลผลข้อมูล: _loadUser
Future<void> _loadUser() async {
    try {
      final user = await _authService.getCurrentUser();
      if (mounted) {
                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
                // คำสั่ง setState จะกระตุ้นให้ Flutter ทำการวาดหน้าจอ (build) ใหม่อีกครั้งเพื่ออัปเดตข้อมูลที่เปลี่ยนไป
setState(() {
          _isLoading = false;
        });
      }
    }
  }

    // ฟังก์ชัน build ทำหน้าที่วาดหน้าจอ (UI) และจัดวาง Widget ต่างๆ ภายในหน้านี้
@override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor, size: 24),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'ข้อความ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: primaryColor,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.black54, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? const Center(child: Text('กรุณาเข้าสู่ระบบเพื่อดูข้อความ', style: TextStyle()))
              :               // StreamBuilder ใช้สำหรับรอรับข้อมูลแบบ Real-time ถ้ามีข้อมูลส่งมาใหม่ หน้าจอจะถูกอัปเดตอัตโนมัติโดยไม่ต้องกดรีเฟรช
StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getUserChats(_currentUser!.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อความ', style: TextStyle()));
                    }

                    final chats = snapshot.data?.docs ?? [];

                    if (chats.isEmpty) {
                      return const Center(
                        child: Text(
                          'ยังไม่มีข้อความ',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chats.length,
                      separatorBuilder: (context, index) => _buildDivider(),
                      itemBuilder: (context, index) {
                        final chatData = chats[index].data() as Map<String, dynamic>;
                        final chatId = chats[index].id;
                        
                        final dormName = chatData['dormName'] ?? 'หอพัก';
                        final lastMessage = chatData['lastMessage'] ?? '';
                        final lastMessageTime = (chatData['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now();
                        
                        String timeStr;
                        final now = DateTime.now();
                        if (now.difference(lastMessageTime).inDays == 0 && now.day == lastMessageTime.day) {
                          timeStr = DateFormat('HH:mm').format(lastMessageTime);
                        } else if (now.difference(lastMessageTime).inDays == 1 || (now.difference(lastMessageTime).inDays == 0 && now.day != lastMessageTime.day)) {
                          timeStr = 'เมื่อวาน';
                        } else {
                          timeStr = DateFormat('d MMM').format(lastMessageTime);
                        }

                        // Just an example logic for initial letter
                        final initialLetter = dormName.isNotEmpty ? dormName[0].toUpperCase() : 'H';

                        return _buildChatItem(
                          name: dormName,
                          message: lastMessage,
                          time: timeStr,
                          unreadCount: 0, // Implement real unread count if needed
                          isInitial: true,
                          initialLetter: initialLetter,
                          bgColor: const Color(0xFFD0D7FF),
                          textColor: primaryColor,
                          onTap: () {
                                                        // คำสั่ง Navigator.push ใช้สำหรับเปลี่ยนหน้าต่างไปยังหน้าจอใหม่
Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                  dormId: int.tryParse(chatData['dormId'].toString()) ?? 0,
                                  dormName: dormName,
                                  chatIdOverride: chatId,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 80, right: 20),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildChatItem({
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    bool isOnline = false,
    String? imageUrl,
    bool isInitial = false,
    String? initialLetter,
    Color? bgColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    const textDarkColor = Color(0xFF1F2937);
    const primaryColor = Color(0xFF3F6DE3);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: bgColor ?? Colors.grey.shade200,
                  backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                  child: isInitial && initialLetter != null && imageUrl == null
                      ? Text(
                          initialLetter,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor ?? Colors.white,
                          ),
                        )
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981), // Green dot
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Message Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textDarkColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                          color: unreadCount > 0 ? primaryColor : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: unreadCount > 0 ? textDarkColor : Colors.grey.shade500,
                            fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
