import 'package:flutter/material.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'friend_item_message_list.dart';

class CreateChat extends StatefulWidget {
  CreateChat({Key? key, required this.friendsList, required this.fetchChats}) : super(key: key);

  final List<UserEntity> friendsList;
  final Future<void> Function() fetchChats;

  @override
  State<CreateChat> createState() => _CreateChatState();
}

class _CreateChatState extends State<CreateChat> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleDialog(
        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        backgroundColor: const Color.fromRGBO(24, 24, 24, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Center(
          child: Text(
            'Create Chat',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        children: [
          SizedBox(
            width: 300,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.friendsList.length,
                    itemBuilder: (context, index) {
                      return FriendItemMessages(
                        userEntity: widget.friendsList[index],
                        fetchChats: widget.fetchChats,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
