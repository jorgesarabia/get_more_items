import 'package:flutter/material.dart';
import 'package:get_more_items/presentation/chat/chat_screen.dart';
import 'package:get_more_items/presentation/infinite_scroll/infinite_scroll.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
              child: const Text('Open chat'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfiniteScroll()),
                );
              },
              child: const Text('Open infinite scroll library'),
            ),
          ],
        ),
      ),
    );
  }
}
