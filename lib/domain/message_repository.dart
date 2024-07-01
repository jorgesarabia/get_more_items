import 'package:get_more_items/domain/message_entity.dart';

abstract class MessageRepository {
  Future<void> getMessages();
  Future<void> loadMoreMessages();
  Stream<List<MessageEntity>> listenForNewMessages();
  Future<void> stopListening();
}
