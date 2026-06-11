import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_booking/models/dormitory.dart';
import 'package:just_booking/services/chat_service.dart';
import 'package:just_booking/users/chat_screen.dart';
import 'package:intl/intl.dart';
import '../core/localization/localization_extension.dart';

/// หน้าจอรวมแชทของเจ้าของหอพัก แสดงรายชื่อผู้เช่าที่ทักเข้ามาสอบถาม

class OwnerChatDashboard extends StatefulWidget {
  final List<Dormitory> dormitories;

  const OwnerChatDashboard({super.key, required this.dormitories});

  @override
  State<OwnerChatDashboard> createState() => _OwnerChatDashboardState();
}

class _OwnerChatDashboardState extends State<OwnerChatDashboard> {
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    if (widget.dormitories.isEmpty) {
      return Center(
        child: Text(
          context.l10n.chatNoDormitory,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Get all chat streams for the owner's dormitories
    List<Stream<QuerySnapshot>> chatStreams = widget.dormitories
        .map((dorm) => _chatService.getDormChats(dorm.id))
        .toList();

    // Since StreamZip isn't available by default without async package, we can combine them using a custom method, 
    // or display them in sections for each dormitory.
    // Displaying sections per dorm is easier and looks good.

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dorm = widget.dormitories[index];
                return _buildDormChatSection(dorm);
              },
              childCount: widget.dormitories.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDormChatSection(Dormitory dorm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            '${context.l10n.chatTitlePrefix}${dorm.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _chatService.getDormChats(dorm.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text(context.l10n.chatErrorLoading);
            }

            final chats = snapshot.data?.docs ?? [];

            if (chats.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  context.l10n.chatNoMessages,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final chat = chats[index].data() as Map<String, dynamic>;
                final chatId = chats[index].id;
                
                final userName = chat['userName'] ?? context.l10n.chatUserUnknown;
                final lastMessage = chat['lastMessage'] ?? '';
                final lastMessageTime = (chat['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now();
                final timeStr = DateFormat('HH:mm').format(lastMessageTime);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF5A84ED).withOpacity(0.1),
                    child: Text(
                      userName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Color(0xFF5A84ED), fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    lastMessage,
                    style: TextStyle(color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    timeStr,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          dormId: dorm.id,
                          dormName: dorm.name,
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
        const SizedBox(height: 24),
      ],
    );
  }
}
