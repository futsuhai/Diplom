import 'package:flutter/material.dart';
import '../../../components/app_post_field.dart';

class PostFieldHome extends StatelessWidget{
  PostFieldHome({super.key});

  final controllerNewPost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppPostField(
            controller: controllerNewPost,
            labelText: "What's new with you?",
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.image,
                color: Colors.grey[800],
              ),
              iconSize: 30.0,
              padding: const EdgeInsets.all(2.0),
              color: Theme.of(context).colorScheme.background,
              splashRadius: 10.0,
              constraints: const BoxConstraints(
                maxHeight: 40.0,
                maxWidth: 40.0,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.grey[800],
              ),
              iconSize: 30.0,
              padding: const EdgeInsets.all(2.0),
              color: Theme.of(context).colorScheme.background,
              splashRadius: 10.0,
              constraints: const BoxConstraints(
                maxHeight: 40.0,
                maxWidth: 40.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

}