import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:client_id/feature/posts/domain/entity/post/post_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../../app/ui/app_loader.dart';
import '../../../../../../app/ui/components/app_snackBar.dart';
import '../../../../../auth/domain/auth_state/auth_cubit.dart';

class PostItem extends StatelessWidget{
  const PostItem({super.key, required this.postEntity,required this.userEntity});

  final PostEntity postEntity;
  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(35, 34, 32, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child:  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      userEntity.image),
                  ),
                ),
                 Text(
                  userEntity.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert),
                  color: const Color.fromRGBO(140, 140, 139, 1),
                ),
              ],
            ),
            // Text Post
            Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                            postEntity.content,
                            style: const TextStyle(
                              color: Color.fromRGBO(140, 140, 139, 1),
                              height: 1.2,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                      textScaleFactor: 1.0,
                    ),
                  ],
                )),
            // Post Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth * (3 / 4), // aspect ratio of 4:3
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.network(
                        postEntity.image ?? "",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}