// lib/presentation/live_chat/live_chat_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'live_chat_message.dart';

class LiveChatList extends StatelessWidget {
  final String liveStreamId;

  const LiveChatList({super.key, required this.liveStreamId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('active_livestreams')
          .doc(liveStreamId)
          .collection('messages')
          .orderBy('createdAt', descending: true) // ⬅️ último mensaje arriba
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        return ListView.builder(
          reverse: true, // ⬅️ hace que se vea el más reciente abajo
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            return LiveChatMessage(
              name: data['name'] ?? 'Anon',
              message: data['message'] ?? '',
              avatarUrl: data['avatarUrl'] ??
                  'https://ui-avatars.com/api/?name=User', // fallback avatar
            );
          },
        );
      },
    );
  }
}
