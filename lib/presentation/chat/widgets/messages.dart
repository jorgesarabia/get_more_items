part of '../chat_screen.dart';

class _Messages extends StatefulWidget {
  const _Messages(this.repository);

  final MessageRepository repository;

  @override
  State<_Messages> createState() => _MessagesState();
}

class _MessagesState extends State<_Messages> {
  ScrollController? _scrollController = ScrollController();
  bool _isGettingMoreMessages = true;
  int _lastLength = 0;
  bool _mustNotJumpToBottom = false;

  final List<MessageEntity> _messages = [];
  late final MessageRepository _messageRepository;

  @override
  void initState() {
    super.initState();
    _messageRepository = widget.repository;
    _scrollController?.addListener(_loadMoreMessages);
    _scrollController?.addListener(_setScrollToBottom);
    _messageRepository.getMessages().then((messages) {
      _messages.addAll(messages);
      setState(() => _isGettingMoreMessages = false);
      _scrollController?.jumpTo(0.0);
    });
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
      // _scrollController?.jumpTo(_scrollController?.position.maxScrollExtent ?? 0.0);
      _scrollController?.jumpTo(0.0);
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
    // print(position.pixels);
    // print(position.maxScrollExtent);
    final diff = position.maxScrollExtent - position.pixels;
    print(diff);
    if (diff > 50 || _isGettingMoreMessages) return;

    setState(() => _isGettingMoreMessages = true);

    _isGettingMoreMessages = true;
    final newMessages = await _messageRepository.loadMoreMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messages.addAll(newMessages);
      setState(() => _isGettingMoreMessages = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        if (_messages.length != _lastLength) {
          _lastLength = index + 1;
          // _scrollTo();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isGettingMoreMessages && index == _messages.length - 1) const CircularProgressIndicator(),
            _MessageContainer(
              key: Key(_messages[index].id.toString()),
              message: _messages[index],
            ),
          ],
        );
      },
    );
  }
}
