import 'package:client_id/app/ui/app_loader.dart';
import 'package:client_id/feature/posts/domain/entity/post/ui/post_item.dart';
import 'package:client_id/feature/posts/domain/state/post_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';

class PostListProfile extends StatelessWidget{
  const PostListProfile({super.key, required this.userEntity});

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        // errors
      },
      builder: (context, state) {
        if(state.postList.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.postList.length,
            itemBuilder: (context, index) {
              return PostItem(postEntity: state.postList[index], userEntity: userEntity,);
            },
          );
        }
        if(state.asyncSnapshot?.connectionState == ConnectionState.waiting){
          return const AppLoader();
        }
        return const SizedBox.shrink();
      },
    );
  }
}

