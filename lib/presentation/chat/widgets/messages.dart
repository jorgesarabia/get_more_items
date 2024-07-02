part of '../chat_screen.dart';

class _Messages extends StatefulWidget {
  const _Messages(this.repository);

  final MessageRepository repository;

  @override
  State<_Messages> createState() => _MessagesState();
}

class _MessagesState extends State<_Messages> {
  List<MessageEntity> _messages = [];
  ScrollController? _scrollController = ScrollController();
  bool _isGettingMoreMessages = false;
  int _lastLength = 0;
  bool _mustNotJumpToBottom = false;
  final Set<MessageSizeHelper> _oldSet = {};
  final Set<MessageSizeHelper> _newSet = {};
  late final MessageRepository _messageRepository;
  int _getLenght = 0;

  @override
  void initState() {
    _messageRepository = widget.repository;
    _scrollController?.addListener(_loadMoreMessages);
    _scrollController?.addListener(_setScrollToBottom);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_loadMoreMessages);
    _scrollController?.removeListener(_setScrollToBottom);
    _scrollController?.dispose();
    _scrollController = null;
    super.dispose();
  }

  void _scrollTo([int durationInMilliseconds = 200]) {
    Future.delayed(Duration(milliseconds: durationInMilliseconds)).then((_) {
      if (_mustNotJumpToBottom) return;
      _scrollController?.jumpTo(_scrollController?.position.maxScrollExtent ?? 0.0);
    });
  }

  void _setScrollToBottom() {
    final position = _scrollController?.position;
    if (position == null) return;
    if (position.pixels == position.maxScrollExtent) {
      _mustNotJumpToBottom = false;
    }
  }

  Future<void> _loadMoreMessages() async {
    final position = _scrollController?.position;
    if (position == null || _messages.isEmpty) return;
    if (position.pixels > 20 || _isGettingMoreMessages) return;

    if (_getLenght == 0) setState(() => _isGettingMoreMessages = true);

    _oldSet.addAll(_newSet.toList());

    _mustNotJumpToBottom = true;
    _getLenght = await _messageRepository.loadMoreMessages();

    if (_isGettingMoreMessages) setState(() => _isGettingMoreMessages = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final heigth = _computeHeight();
      _scrollController?.jumpTo(heigth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messageRepository.listenForNewMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        _messages = snapshot.data ?? [];

        return ListView.builder(
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            if (_messages.length != _lastLength) {
              _lastLength = index + 1;
              _scrollTo();
            }

            final messageEntity = _messages[index];

            _newSet.add(
              MessageSizeHelper(
                id: messageEntity.id,
                height: calculateSize(messageEntity).height,
              ),
            );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isGettingMoreMessages && index == 0) const CircularProgressIndicator(),
                _MessageContainer(
                  key: Key(messageEntity.id.toString()),
                  message: messageEntity,
                ),
              ],
            );
          },
        );
      },
    );
  }

  double _computeHeight() {
    final diff = _newSet.difference(_oldSet);
    double newHeight = 0.0;
    for (var element in diff) {
      newHeight += element.height;
    }

    return newHeight;
  }

  Size calculateSize(MessageEntity messageEntity) {
    final textStyle = DefaultTextStyle.of(context).style;
    final maxWidth = MediaQuery.of(context).size.width - 16 * 2;

    final idTextPainter = TextPainter(
      text: TextSpan(text: 'ID: ${messageEntity.id}', style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    final messageTextPainter = TextPainter(
      text: TextSpan(text: messageEntity.message, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    final idTextSize = idTextPainter.size;
    final messageTextSize = messageTextPainter.size;

    final totalWidth = max(idTextSize.width, messageTextSize.width) + 2 * 8;
    final totalHeight = idTextSize.height + messageTextSize.height + 2 * 8;

    final totalSize = Size(totalWidth + 2 * 8, totalHeight + 2 * 8);

    return totalSize;
  }
}
