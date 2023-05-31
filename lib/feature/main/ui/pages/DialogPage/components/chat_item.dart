import 'package:client_id/feature/main/ui/pages/DialogPage/components/entity/chat_entity.dart';
import 'package:client_id/feature/main/ui/pages/DialogPage/components/entity/message_entity.dart';
import 'package:client_id/feature/main/ui/pages/FriendsPage/components/user_profile.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/di/init_di.dart';
import '../../../../../../app/domain/app_api.dart';
import '../../../../../auth/data/dto/user_dto.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'chat_page.dart';
import 'package:intl/intl.dart';

class ChatItem extends StatefulWidget {
  ChatItem({Key, key, required this.chatEntity, required this.fetchChats});

  final ChatEntity chatEntity;
  final Future<void> Function() fetchChats;

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  final AppApi appApi = locator.get<AppApi>();
  MessageEntity messageEntity = MessageEntity(
      id: (1), chatId: 1, authorId: 1, text: "TestMessage", sentTime: DateTime.now()
  );

  @override
  void initState() {
    super.initState();
    _fetchLastMessage(widget.chatEntity.id.toString());
  }

  Future<void> _fetchLastMessage(String id) async {
    final response = await appApi.fetchLastMessage(id);
    final MessageEntity lastMessage = MessageEntity.fromJson(response.data);
      setState(() {
        messageEntity = lastMessage;
      });
  }

  Future<UserEntity> getProfileWithId(String id) async {
    final response = await appApi.getProfileWithId(id);
    return UserDto.fromJson(response.data["data"]).toEntity();
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserEntity>(
      future: getProfileWithId(widget.chatEntity.idUser.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('');
        } else {
          final userEntity = snapshot.data;
          return Column(
            children: [
              // Header post
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserPage(userEntity: userEntity!),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userEntity?.image ?? ""),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              userEntity: userEntity!,
                              chatEntity: widget.chatEntity,
                              fetchChats: widget.fetchChats,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              userEntity?.username ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0),
                             child: Text(
                              messageEntity.text,
                              style: const TextStyle(
                                color: Color.fromRGBO(140, 140, 139, 1),
                              ),
                          ),
                           ),
                        ],
                      ),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        Text(
                          DateFormat.Hm().format(messageEntity.sentTime),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(140, 140, 139, 1)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16),
                child: Divider(
                  thickness: 0.9,
                  color: Color.fromRGBO(140, 140, 139, 1),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
