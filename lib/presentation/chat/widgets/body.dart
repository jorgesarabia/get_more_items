part of '../chat_screen.dart';

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late MessageRepository _repository;

  @override
  void initState() {
    _repository = MessageRepositoryImpl(MessageGenerator());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _Messages(_repository)),
        //   ElevatedButton(
        //     onPressed: () => _repository.loadMoreMessages(),
        //     child: const Text('Get more messages'),
        //   ),
      ],
    );
  }
}
