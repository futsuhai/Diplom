import 'package:flutter/cupertino.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'friend_item.dart';


class FriendsList extends StatelessWidget{
  const FriendsList({super.key, required this.friendList, required this.getAllFriends});

  final List<UserEntity> friendList;
  final Future<void> Function() getAllFriends;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: friendList.length,
      itemBuilder: (context, index) {
        return FriendItem(userEntity: friendList[index], getAllFriends: getAllFriends,);
      },
    );
  }
}

