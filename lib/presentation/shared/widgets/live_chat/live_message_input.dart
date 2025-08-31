// lib/presentation/live_chat/live_message_input.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LiveMessageInput extends StatefulWidget {
  final String liveStreamId;

  const LiveMessageInput({super.key, required this.liveStreamId});

  @override
  State<LiveMessageInput> createState() => _LiveMessageInputState();
}

class _LiveMessageInputState extends State<LiveMessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final text = _controller.text.trim();

    if (text.isEmpty || user == null) return;

    setState(() => _sending = true);

    try {
      await FirebaseFirestore.instance
          .collection('active_livestreams')
          .doc(widget.liveStreamId)
          .collection('messages')
          .add({
        'message': text,
        'name': user.displayName ?? 'Anónimo',
        'avatarUrl': user.photoURL ??
            'https://ui-avatars.com/api/?name=${user.displayName ?? "User"}',
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar mensaje: $e')),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Envía un mensaje...',
                  filled: true,
                  fillColor: Colors.black26,
                  hintStyle: const TextStyle(color: Colors.white54),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            _sending
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
          ],
        ),
      ),
    );
  }
}
