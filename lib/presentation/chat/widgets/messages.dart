part of '../chat_screen.dart';

class _Messages extends StatefulWidget {
  const _Messages(this.repository);

  final MessageRepository repository;

  @override
  State<_Messages> createState() => _MessagesState();
}

class _MessagesState extends State<_Messages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.repository.listenForNewMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data ?? [];

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _MessageContainer(message: messages[index]);
          },
        );
      },
    );
  }
}
