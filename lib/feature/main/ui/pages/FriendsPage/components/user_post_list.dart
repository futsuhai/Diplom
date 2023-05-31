import 'package:client_id/feature/main/ui/pages/FriendsPage/components/post_item_users.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import '../../../../../posts/domain/entity/post/post_entity.dart';


class UserPostList extends StatelessWidget{
  const UserPostList({super.key, required this.userEntity, required this.postList});

  final UserEntity userEntity;
  final List<PostEntity> postList;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: postList.length,
      itemBuilder: (context, index) {
        return PostItemUsers(userEntity: userEntity, postEntity: postList[index],);
      },
    );
  }
}

