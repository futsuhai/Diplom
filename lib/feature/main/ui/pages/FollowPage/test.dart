import 'package:client_id/feature/posts/domain/entity/post/ui/post_list_profile.dart';
import 'package:flutter/material.dart';

import '../../../../../app/di/init_di.dart';
import '../../../../../app/domain/app_api.dart';

class Test extends StatelessWidget {
  final AppApi appApi = locator.get<AppApi>();

  Test({Key? key}) : super(key: key);

  Future<void> getAllUsers() async {
    try {
      // Call the getAllUsers() method
      final userList = await appApi.getAllUsers();


    } catch (error) {
      // Handle any errors that occur
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        backgroundColor: Colors.grey[600],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: getAllUsers,
            child: Text('Choose Image'),
          ),
        ],
      ),
    );
  }
}
