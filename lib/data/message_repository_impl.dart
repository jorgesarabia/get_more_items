import 'dart:async';

import 'package:get_more_items/data/message_generator.dart';
import 'package:get_more_items/domain/message_entity.dart';
import 'package:get_more_items/domain/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this.messageGenerator);

  final MessageGenerator messageGenerator;

  @override
  Future<List<MessageEntity>> getMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    final messages = List.generate(10, (_) {
      return messageGenerator.generate();
    });
    return messages;
  }

  @override
  Future<List<MessageEntity>> loadMoreMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    final messages = List.generate(20, (_) {
      return messageGenerator.generate();
    });
    return messages;
  }
}
