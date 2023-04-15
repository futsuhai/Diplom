import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../auth/domain/entities/user_entity/user_entity.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key, required this.userEntity}) : super(key: key);
  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UserHomeScreen"),
        actions: [
          IconButton(
              onPressed: () => context.read<AuthCubit>().getProfile(),
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () => context.read<AuthCubit>().logOut(),
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Column(
        children: [
          Text("username: ${userEntity.username}"),
          const SizedBox(height: 20),
          Text("accessToken: ${userEntity.accessToken}"),
          const SizedBox(height: 20),
          Text("refreshToken: ${userEntity.refreshToken}"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
