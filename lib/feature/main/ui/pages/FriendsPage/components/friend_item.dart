import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:flutter/material.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 14, bottom: 14, left: 8),
          child:  CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                userEntity.image),
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
        Padding(
          padding: const EdgeInsets.only(right: 20.0, top: 8),
          child: IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.delete),
            iconSize: 28,
            padding: const EdgeInsets.only(left: 48),
            color: const Color.fromRGBO(140, 140, 139, 1),
          ),
        ),
        // buttons
      ],
    );
  }
}
