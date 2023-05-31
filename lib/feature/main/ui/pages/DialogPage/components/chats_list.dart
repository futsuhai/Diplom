import 'package:flutter/cupertino.dart';

import 'chat_item.dart';
import 'entity/chat_entity.dart';

class ChatsList extends StatelessWidget{
  const ChatsList({super.key, required this.chatsList, required this.fetchChats});

  final List<ChatEntity> chatsList;
  final Future<void> Function() fetchChats;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chatsList.length,
      itemBuilder: (context, index) {
        return ChatItem(chatEntity: chatsList[index], fetchChats: fetchChats,);
      },
    );
  }
}

