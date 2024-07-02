import 'dart:async';

import 'package:get_more_items/data/message_generator.dart';
import 'package:get_more_items/domain/message_entity.dart';
import 'package:get_more_items/domain/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl(this.messageGenerator);

  final MessageGenerator messageGenerator;
  final Set<MessageEntity> _messages = {};
  final List<MessageEntity> _loadedMessages = [];

  StreamController<List<MessageEntity>>? _messageController;

  @override
  Future<void> getMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    final messages = List.generate(5, (_) {
      return messageGenerator.generate();
    });
    _loadMessages(messages: messages);
  }

  @override
  Future<void> loadMoreMessages() async {
    if (_loadedMessages.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));
      final messages = List.generate(20, (_) {
        return messageGenerator.generate();
      });
      _loadedMessages.addAll(messages.reversed);
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    _sendLessMessages();
  }

  void _sendLessMessages() {
    late final List<MessageEntity> poppedList;
    if (_loadedMessages.length >= 2) {
      int firstIndex = 0;
      int secondIndex = 1;
      poppedList = _loadedMessages.sublist(firstIndex, secondIndex + 1);
      _loadedMessages.removeRange(firstIndex, secondIndex + 1);
    } else {
      poppedList = [_loadedMessages[0]];
      _loadedMessages.removeLast();
    }

    _loadMessages(messages: poppedList, isAfter: false);
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
