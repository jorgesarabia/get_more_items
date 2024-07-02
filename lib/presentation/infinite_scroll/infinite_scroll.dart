import 'package:flutter/material.dart';

part 'widgets/body.dart';

class InfiniteScroll extends StatelessWidget {
  const InfiniteScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Infinite Scroll')),
      body: const Placeholder(),
    );
  }
}
