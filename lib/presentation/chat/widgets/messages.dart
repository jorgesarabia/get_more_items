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
  int _targetId = -1;

  final _globalKey = GlobalKey();
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

    if (position.pixels > 20 || _isGettingMoreMessages) return;

    setState(() => _isGettingMoreMessages = true);
    _mustNotJumpToBottom = true;
    _targetId = _messages.first.id;
    await _messageRepository.loadMoreMessages();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      double jumpInside = _scrollController!.position.extentInside - 100;
      for (int x = 0; x < 1000; x++) {
        final targetContext = _globalKey.currentContext;
        final position = _scrollController!.position.pixels;
        if (targetContext == null) {
          await Future.delayed(const Duration(milliseconds: 100));
          _scrollController?.jumpTo(position + jumpInside);
        } else {
          final renderBox = targetContext.findRenderObject() as RenderBox?;
          final offset = renderBox?.localToGlobal(Offset.zero).dy;
          if (offset != null) {
            _scrollController?.jumpTo(position + offset);
            x = 2000;
          }
          Scrollable.ensureVisible(
            targetContext,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        }
      }
      setState(() => _isGettingMoreMessages = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
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

                final message = _messages[index];

                return Column(
                  key: message.id == _targetId ? _globalKey : null,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // if (_isGettingMoreMessages && index == 0) const CircularProgressIndicator(),
                    _MessageContainer(
                      key: Key(message.id.toString()),
                      message: message,
                    ),
                  ],
                );
              },
            );
          },
        ),
        if (_isGettingMoreMessages)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(1),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
