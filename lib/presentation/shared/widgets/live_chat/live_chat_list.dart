// lib/presentation/live_chat/live_chat_list.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'live_chat_message.dart';

class LiveChatList extends StatelessWidget {
  final String subjectId;
  final int classNumber;

  const LiveChatList({
    super.key,
    required this.subjectId,
    required this.classNumber,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> _stream() {
    return FirebaseFirestore.instance
        .collection('subjects')
        .doc(subjectId)
        .collection('classes')
        .doc(classNumber.toString())
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(200)
        .withConverter<Map<String, dynamic>>(
          fromFirestore: (s, _) => s.data() ?? {},
          toFirestore: (m, _) => m,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _stream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sé el primero en comentar 👋',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            );
          }

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return LiveChatMessage(
                name: data['name'] ?? 'Anónimo',
                message: data['message'] ?? '',
                avatarUrl: data['avatarUrl'] ??
                    'https://ui-avatars.com/api/?name=User',
              );
            },
          );
        });
  }
}
