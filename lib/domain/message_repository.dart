import 'package:get_more_items/domain/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> getMessages();
  Future<List<MessageEntity>> loadMoreMessages();
}
