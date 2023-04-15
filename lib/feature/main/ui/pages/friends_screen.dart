import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user_entity/user_entity.dart';

class FriendsScreen extends StatelessWidget{
  FriendsScreen({Key? key, required userEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FriendsScreen"),
      ),
    );
  }

}