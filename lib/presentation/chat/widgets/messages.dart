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
  late final MessageRepository _messageRepository;

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

    if (position.pixels > position.maxScrollExtent - 20 || _isGettingMoreMessages) return;

    print(position.pixels);
    print(position.maxScrollExtent);

    setState(() => _isGettingMoreMessages = true);

    _mustNotJumpToBottom = true;
    await _messageRepository.loadMoreMessages();

    setState(() => _isGettingMoreMessages = false);
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo());
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
          reverse: true,
          controller: _scrollController,
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            if (_messages.length != _lastLength) {
              _lastLength = index + 1;
              _scrollTo();
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
      },
    );
  }
}
