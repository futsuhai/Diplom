import 'package:flutter/material.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'create_post_dialog.dart';

class CreatePostContainer extends StatelessWidget {
  const CreatePostContainer({Key? key, required this.userEntity,}) : super(key: key);
  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(35, 34, 32, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "What's new with you?",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(140, 140, 139, 1),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreatePostDialog(userEntity: userEntity,);
                  },
                );
              },
              icon: const Icon(
                Icons.add,
                color: Color.fromRGBO(140, 140, 139, 1),
              ),
              iconSize: 32.0,
              padding: const EdgeInsets.all(2.0),
              color: const Color.fromRGBO(140, 140, 139, 1),
              splashRadius: 10.0,
              constraints: const BoxConstraints(
                maxHeight: 40.0,
                maxWidth: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}