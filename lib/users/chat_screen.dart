import 'package:flutter/material.dart';
import 'package:just_booking/models/user.dart';
import 'package:just_booking/services/auth_service.dart';
import 'package:just_booking/services/chat_service.dart';
import 'package:intl/intl.dart';
import '../core/localization/localization_extension.dart';

/// หน้าห้องแชทสนทนาระหว่างผู้เช่าและเจ้าของหอพัก
/// หน้านี้จะรับพารามิเตอร์ dormId และ dormName เพื่อระบุว่าคุยเกี่ยวกับหอพักไหน

class ChatScreen extends StatefulWidget {
  final int dormId;
  final String dormName;
  final String? chatIdOverride; // ถ้ามี roomId หรือแชทที่เคยคุยแล้วส่งมา จะใช้แทนการสร้างใหม่

  const ChatScreen({
    super.key,
    required this.dormId,
    required this.dormName,
    this.chatIdOverride,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Service สำหรับจัดการฐานข้อมูลแชทและการส่งข้อความ
  final ChatService _chatService = ChatService();
  // Service สำหรับดึงข้อมูลผู้ใช้งานที่ล็อกอินอยู่
  final AuthService _authService = AuthService();
  // ตัวควบคุมช่องพิมพ์ข้อความ (TextField)
  final TextEditingController _messageController = TextEditingController();
  
  User? _currentUser; // เก็บข้อมูลผู้ใช้ปัจจุบัน (เพื่อตรวจสอบว่าตัวเองเป็นคนพิมพ์หรือไม่)
  late String _chatId; // ไอดีห้องแชทที่จะใช้โหลดข้อความ
  bool _isLoading = true; // สถานะการโหลดตอนเปิดหน้าแชท

  @override
  void initState() {
    super.initState();
    // เมื่อเปิดหน้านี้ จะเรียกฟังก์ชันเตรียมความพร้อมห้องแชททันที
    _initChat();
  }

  // ฟังก์ชันเตรียมการก่อนเริ่มแชท (ดึงข้อมูลผู้ใช้ และดึง/สร้าง Chat ID)
  Future<void> _initChat() async {
    try {
      // ดึงข้อมูล User ปัจจุบันจากระบบ Auth
      final user = await _authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
          // กำหนดรหัสห้องแชท (Chat ID) โดยถ้าไม่มีส่งมา จะสร้างใหม่จาก (dormId + userId)
          _chatId = widget.chatIdOverride ?? _chatService.getChatId(widget.dormId, user.id);
          _isLoading = false; // ปิดสถานะการโหลด
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // แสดงแจ้งเตือนกรณีดึงข้อมูลผู้ใช้ไม่สำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.chatFailedUserInfo)),
        );
      }
    }
  }

  // ฟังก์ชันส่งข้อความแชทไปหาคู่สนทนา
  Future<void> _sendMessage() async {
    // ลบช่องว่างหน้า/หลังข้อความ และเช็คว่าว่างเปล่าหรือไม่
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentUser == null) return; // ถ้าข้อความว่าง หรือยังไม่ได้ล็อกอิน ให้หยุดการทำงาน

    // ล้างข้อความในช่องพิมพ์ทันทีเพื่อให้พิมพ์ข้อความถัดไปได้
    _messageController.clear();
    try {
      // เรียกใช้ Service ส่งข้อความไปยัง Firebase / Database
      await _chatService.sendMessage(
        _chatId,
        widget.dormId,
        _currentUser!,
        text,
        dormName: widget.dormName,
      );
    } catch (e) {
      if (mounted) {
        // หากส่งข้อความไม่สำเร็จ จะแสดงแจ้งเตือน (SnackBar)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.chatFailedSendMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. ตรวจสอบสถานะการโหลด: ถ้ากำลังโหลด ให้แสดงวงกลมหมุนตรงกลางจอ
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. ตรวจสอบข้อมูลผู้ใช้: ถ้าดึงข้อมูลไม่ได้ (ไม่ได้ล็อกอิน) ให้แสดงข้อความแจ้งเตือนให้ออกจากหน้านี้
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.chatErrorTitle)),
        body: Center(child: Text(context.l10n.chatLoginRequired)),
      );
    }

    // 3. แสดงหน้าจอแชทหลัก
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC), // สีพื้นหลังหน้าแชท (เทาอ่อน)
      // ส่วนหัวของหน้า (AppBar) แสดงชื่อหอพัก
      appBar: AppBar(
        title: Text(
          widget.dormName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5, // สร้างเงาบางๆ ใต้ AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context), // ปุ่มกดย้อนกลับ
        ),
      ),
      // ส่วนเนื้อหาหลัก (Body) แบ่งเป็น 2 ส่วน: 1.กล่องแชทด้านบน 2.ช่องพิมพ์ด้านล่าง
      body: Column(
        children: [
          // Expanded ทำหน้าที่ขยายพื้นที่ให้กล่องแสดงข้อความใช้พื้นที่จอที่เหลือทั้งหมด
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              // StreamBuilder ใช้เชื่อมต่อข้อมูลแชทแบบ Real-time ถ้ามีข้อความใหม่ หน้าจอจะอัปเดตอัตโนมัติ
              stream: _chatService.getMessages(_chatId),
              builder: (context, snapshot) {
                // ขณะรอดึงข้อมูลข้อความ ให้แสดงวงกลมโหลด
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ถ้ามี error ในการดึงแชท
                if (snapshot.hasError) {
                  return Center(child: Text(context.l10n.chatErrorLoading));
                }

                final messages = snapshot.data ?? []; // รับข้อมูลรายการข้อความทั้งหมด

                // ถ้าไม่มีข้อความเลย ให้แสดงคำว่า "เริ่มการสนทนา"
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      context.l10n.chatStartConversation,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // สร้าง List ข้อความแบบเลื่อนได้ (ListView)
                return ListView.builder(
                  reverse: true, // ตั้งเป็น true เพื่อให้ข้อความใหม่ล่าสุดอยู่ด้านล่างเสมอ (แบบแอพ Line/Messenger)
                  physics: const BouncingScrollPhysics(), // ทำให้การเลื่อนสุดขอบมีการเด้งสมูท
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    // ตรวจสอบว่าข้อความนี้ "เรา" เป็นคนพิมพ์หรือไม่ โดยเทียบ senderId กับ User ID ของเรา
                    final isMe = msg.senderId == _currentUser!.id.toString();
                    // วาดกล่องลูกโป่งข้อความ (Message Bubble)
                    return _buildMessageBubble(msg, isMe);
                  },
                );
              },
            ),
          ),
          // นำฟังก์ชันช่องพิมพ์ข้อความมาวางด้านล่างสุดของจอ
          _buildMessageInput(),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างลูกโป่งข้อความ (Message Bubble) แต่ละอัน
  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    // แปลงเวลา Timestamp จากระบบ ให้เป็นรูปแบบ ชั่วโมง:นาที (เช่น 14:30)
    final timeStr = DateFormat('HH:mm').format(msg.timestamp);

    return Align(
      // ถ้าเป็นข้อความที่เราพิมพ์ ให้อยู่ชิดขวา (centerRight) ถ้าคนอื่นพิมพ์ ให้อยู่ชิดซ้าย (centerLeft)
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          // เปลี่ยนสีพื้นหลังลูกโป่ง: สีน้ำเงิน(สำหรับเรา), สีขาว(สำหรับคู่สนทนา)
          color: isMe ? const Color(0xFF5A84ED) : Colors.white,
          // ตัดมุมลูกโป่งให้มน (Radius) และตัดมุมล่างด้านในให้เป็นมุมฉากตามฝั่งผู้พูด
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), // เงาบางๆ ให้ดูลอยขึ้นมา
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          // จัดตัวหนังสือชิดซ้ายหรือขวาตามผู้พูด
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // แสดงข้อความที่พิมพ์
            Text(
              msg.text,
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF1F2937), // สีข้อความขาว/ดำ
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            // แสดงเวลาด้านล่างข้อความ ขนาดตัวหนังสือเล็ก (fontSize: 10)
            Text(
              timeStr,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างแถบช่องพิมพ์ข้อความด้านล่างสุด
  Widget _buildMessageInput() {
    return Container(
      // เผื่อขอบด้านล่างสำหรับหน้าจอที่มี Home Indicator (ในไอโฟน)
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        // สร้างเส้นขอบบางๆ ด้านบนกั้นระหว่างช่องแชทกับช่องพิมพ์
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Expanded ทำให้ช่องพิมพ์ขยายเต็มพื้นที่จนกว่าจะถึงปุ่มส่ง
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // สีพื้นหลังช่องพิมพ์ (เทาอ่อน)
                borderRadius: BorderRadius.circular(24), // ทำมุมให้โค้งมน
              ),
              child: TextField(
                controller: _messageController, // ตัวควบคุมไว้ดึงข้อความที่พิมพ์
                textInputAction: TextInputAction.send, // เปลี่ยนปุ่ม Enter ในคีย์บอร์ดให้เป็นปุ่มส่ง
                onSubmitted: (_) => _sendMessage(), // เมื่อกด Enter ให้ส่งข้อความ
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: context.l10n.chatHintText, // คำใบ้ในช่อง (เช่น "พิมพ์ข้อความ...")
                  hintStyle: TextStyle(fontSize: 14, color: Colors.black38),
                  border: InputBorder.none, // ลบเส้นขอบสีดำของ TextField ปกติทิ้ง
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // ปุ่มกดส่งข้อความ (ไอคอนจรวดกระดาษ)
          GestureDetector(
            onTap: _sendMessage, // เมื่อกดปุ่ม ให้เรียกฟังก์ชัน _sendMessage
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF5A84ED), // ปุ่มส่งสีน้ำเงิน
                shape: BoxShape.circle, // รูปทรงวงกลม
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
