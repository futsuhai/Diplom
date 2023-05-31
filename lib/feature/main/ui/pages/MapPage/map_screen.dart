import 'package:client_id/feature/posts/domain/entity/post/ui/post_list_profile.dart';
import 'package:flutter/material.dart';

import '../../../../../app/di/init_di.dart';
import '../../../../../app/domain/app_api.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Colors.grey[600],
      ),
      body: Container(),
    );
  }
}
