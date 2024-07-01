import 'dart:math';

import 'package:get_more_items/domain/message_entity.dart';

class MessageGenerator {
  int id = 0;
  final Random _random = Random();
  final List<String> _messages = [
    'Hello, world!',
    'Dart is awesome!',
    'Flutter makes beautiful apps!',
    'Random message generator!',
    'Coding is fun!',
  ];

  MessageEntity generate() {
    final String message = _generateRandomMessage();
    return MessageEntity(id: id++, message: message);
  }

  String _generateRandomMessage() {
    return _messages[_random.nextInt(_messages.length)];
  }
}
