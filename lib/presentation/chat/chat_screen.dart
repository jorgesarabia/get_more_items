import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_more_items/data/message_generator.dart';
import 'package:get_more_items/data/message_repository_impl.dart';
import 'package:get_more_items/domain/message_entity.dart';
import 'package:get_more_items/domain/message_repository.dart';

part 'widgets/body.dart';
part 'widgets/message_container.dart';
part 'widgets/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const _Body(),
    );
  }
}
