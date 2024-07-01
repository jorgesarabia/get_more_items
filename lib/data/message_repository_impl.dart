import 'package:get_more_items/data/message_generator.dart';
import 'package:get_more_items/domain/message_entity.dart';
import 'package:get_more_items/domain/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  const MessageRepositoryImpl(this.messageGenerator);

  final MessageGenerator messageGenerator;

  @override
  Future<List<MessageEntity>> getMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(5, (_) {
      return messageGenerator.generate();
    });
  }

  @override
  Future<List<MessageEntity>> loadMoreMessages() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(2, (_) {
      return messageGenerator.generate();
    });
  }
}
