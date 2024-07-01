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
  late final MessageRepository _messageRepository;

  @override
  void initState() {
    _messageRepository = widget.repository;
    _scrollController?.addListener(_loadMoreMessages);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_loadMoreMessages);
    _scrollController?.dispose();
    _scrollController = null;
    super.dispose();
  }

  Future<void> _loadMoreMessages() async {
    final position = _scrollController?.position;
    if (position == null || _messages.isEmpty) return;

    if (position.pixels > 20 || _isGettingMoreMessages) return;

    setState(() => _isGettingMoreMessages = true);

    await _messageRepository.loadMoreMessages();

    setState(() => _isGettingMoreMessages = false);
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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isGettingMoreMessages && index == 0) const CircularProgressIndicator(),
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
