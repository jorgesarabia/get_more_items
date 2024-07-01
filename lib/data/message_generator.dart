import 'dart:math';

import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:get_more_items/domain/message_entity.dart';

class MessageGenerator {
  int id = 0;
  final Random _random = Random();

  MessageEntity generate() {
    final String message = _generateRandomMessage();
    return MessageEntity(id: id++, message: message);
  }

  String _generateRandomMessage() {
    return lorem(paragraphs: _random.nextInt(2) + 1, words: _random.nextInt(95) + 5);
  }
}
