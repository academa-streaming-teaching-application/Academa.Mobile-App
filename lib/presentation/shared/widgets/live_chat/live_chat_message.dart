// lib/presentation/live_chat/live_chat_message.dart
import 'package:flutter/material.dart';

class LiveChatMessage extends StatelessWidget {
  final String name;
  final String message;
  final String avatarUrl;

  const LiveChatMessage({
    super.key,
    required this.name,
    required this.message,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 4),
                    Text(message, style: const TextStyle(color: Colors.white)),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
