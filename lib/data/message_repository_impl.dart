import 'dart:async';

import 'package:get_more_items/data/message_generator.dart';
import 'package:get_more_items/domain/message_entity.dart';
import 'package:get_more_items/domain/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this.messageGenerator);

  final MessageGenerator messageGenerator;
  final Set<MessageEntity> _messages = {};

  StreamController<List<MessageEntity>>? _messageController;

  @override
  Future<void> getMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    final messages = List.generate(10, (_) {
      return messageGenerator.generate();
    });
    // messages.sort((a, b) => a.id.compareTo(b.id));
    _loadMessages(messages: messages);
  }

  @override
  Future<void> loadMoreMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    final messages = List.generate(2, (_) {
      return messageGenerator.generate();
    });
    // messages.sort((a, b) => a.id.compareTo(b.id));
    _loadMessages(messages: messages);
  }

  void _loadMessages({required List<MessageEntity> messages, bool isAfter = true}) {
    if (messages.isEmpty) return;
    final messageList = _messages.toList();

    _messages.clear();

    if (isAfter) {
      messageList.addAll(messages);
    } else {
      messageList.insertAll(0, messages);
    }

    _messages.addAll(messageList);
    _messageController?.add(_messages.toList());
  }

  @override
  Stream<List<MessageEntity>> listenForNewMessages() {
    if (_messageController?.isClosed ?? true) {
      _messageController = StreamController.broadcast();
      getMessages();
    }

    return _messageController!.stream;
  }

  @override
  Future<void> stopListening() async {
    await _messageController?.close();
    _messageController = null;
  }
}
