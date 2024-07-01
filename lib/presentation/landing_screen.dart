import 'package:flutter/material.dart';
import 'package:get_more_items/presentation/chat/chat_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          child: const Text('Open chat'),
        ),
      ),
    );
  }
}
