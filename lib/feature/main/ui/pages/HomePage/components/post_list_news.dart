import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:client_id/feature/main/ui/pages/HomePage/components/post_item_news.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../posts/domain/entity/post/post_entity.dart';
import 'package:collection/collection.dart';

class PostListNews extends StatelessWidget{
  const PostListNews({super.key, required this.postList, required this.friendsList});

  final List<PostEntity> postList;
  final List<UserEntity> friendsList;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: postList.length,
      itemBuilder: (context, index) {
        final UserEntity friend;
        friend = friendsList.firstWhere((friend) => friend.trueId == postList[index].author?.id.toString());
        return PostItemNews(postEntity: postList[index], friend: friend);
      },
    );
  }
}

