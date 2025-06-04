// lib/presentation/live_chat/live_video_header.dart

import 'package:flutter/material.dart';

class LiveVideoHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String title;

  const LiveVideoHeader({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: const Color.fromARGB(255, 30, 30, 30),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(avatarUrl),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'EN VIVO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
