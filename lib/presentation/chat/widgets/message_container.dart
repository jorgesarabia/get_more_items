part of '../chat_screen.dart';

class _MessageContainer extends StatefulWidget {
  const _MessageContainer({required this.message});

  final MessageEntity message;

  @override
  State<_MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<_MessageContainer> {
  late final MessageEntity _messageEntity;

  @override
  void initState() {
    _messageEntity = widget.message;
    super.initState();
  }

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
  ];

  Color getColorFromInt(int index) {
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: getColorFromInt(_messageEntity.id),
        child: Text(_messageEntity.message),
      ),
    );
  }
}
