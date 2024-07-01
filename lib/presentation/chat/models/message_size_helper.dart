import 'package:equatable/equatable.dart';

class MessageSizeHelper extends Equatable {
  const MessageSizeHelper({
    required this.id,
    required this.height,
  });

  final int id;
  final double height;

  @override
  List<Object?> get props => [id, height];
}
