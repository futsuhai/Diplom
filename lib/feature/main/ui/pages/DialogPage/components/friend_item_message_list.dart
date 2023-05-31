import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/di/init_di.dart';
import '../../../../../../app/domain/app_api.dart';
import 'chat_page.dart';

class FriendItemMessages extends StatelessWidget {
  FriendItemMessages(
      {super.key, required this.userEntity, required this.fetchChats});

  final UserEntity userEntity;
  final AppApi appApi = locator.get<AppApi>();
  final Future<void> Function() fetchChats;

  void _handleButtonClick() async {
    await fetchChats();
  }

  Future<void> _createChat(String id) async {
    try {
      await appApi.createChat(id);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _createChat(userEntity.trueId ?? "default");
        _handleButtonClick();
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatPage(
        //         userEntity: userEntity
        //     ),
        //   ),
        // );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 14, bottom: 14, left: 8),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userEntity.image),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        userEntity.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      userEntity.description,
                      style: const TextStyle(
                        color: Color.fromRGBO(140, 140, 139, 1),
                      ),
                    ),
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
