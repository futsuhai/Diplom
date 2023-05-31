import 'package:client_id/feature/main/ui/pages/FriendsPage/components/user_item.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';


class UsersList extends StatelessWidget{
  const UsersList({super.key, required this.userList, required this.getAllUsers});

  final List<UserEntity> userList;
  final Future<void> Function() getAllUsers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return UserItem(userEntity: userList[index], getAllUsers: getAllUsers,);
      },
    );
  }
}

