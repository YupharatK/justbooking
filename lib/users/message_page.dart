import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3F6DE3);
    const textDarkColor = Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: primaryColor, size: 24),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'ข้อความ',
          style: TextStyle(
            fontFamily: 'Kanit',
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          _buildChatItem(
            name: 'สมชาย',
            message: 'สวัสดีครับ ห้องว่างไหมครับ?',
            time: '10:45',
            unreadCount: 2,
            isOnline: true,
            imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200',
          ),
          _buildDivider(),
          _buildChatItem(
            name: 'อารยา',
            message: 'ขอบคุณมากค่ะ เดี๋ยวจะเข้าไปดูนะคะ',
            time: 'เมื่อวาน',
            unreadCount: 0,
            imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
          ),
          _buildDivider(),
          _buildChatItem(
            name: 'วินัย',
            message: 'สนใจหอพักโซน A ครับ ราคาเท่าไหร่ครับ',
            time: 'จันทร์',
            unreadCount: 0,
            imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
          ),
          _buildDivider(),
          _buildChatItem(
            name: 'กานต์',
            message: 'โอเคครับ เจอกันพรุ่งนี้ครับ',
            time: '2 ส.ค.',
            unreadCount: 0,
            isInitial: true,
            initialLetter: 'K',
            bgColor: const Color(0xFFD0D7FF),
            textColor: primaryColor,
          ),
          _buildDivider(),
          _buildChatItem(
            name: 'นิภา',
            message: 'สอบถามเรื่องค่ามัดจำค่ะ',
            time: '1 ส.ค.',
            unreadCount: 0,
            imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=200',
          ),
          _buildDivider(),
        ],
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
  }) {
    const textDarkColor = Color(0xFF1F2937);
    const primaryColor = Color(0xFF3F6DE3);

    return InkWell(
      onTap: () {},
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
                  child: isInitial && initialLetter != null
                      ? Text(
                          initialLetter,
                          style: TextStyle(
                            fontFamily: 'Kanit',
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
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDarkColor,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontFamily: 'Kanit',
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
                            fontFamily: 'Kanit',
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
                              fontFamily: 'Kanit',
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
