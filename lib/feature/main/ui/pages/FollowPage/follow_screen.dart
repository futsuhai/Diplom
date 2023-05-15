import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../app/ui/app_loader.dart';
import '../../../../../app/ui/components/app_snackBar.dart';
import '../../../../auth/domain/auth_state/auth_cubit.dart';

class FollowScreen extends StatelessWidget {
  FollowScreen({super.key});

  //test follow
  List<String> follow = [
    "lib/assets/post1.png",
    "lib/assets/post2.png",
    "lib/assets/post3.png",
    "lib/assets/post1.png",
    "lib/assets/post2.png",
    "lib/assets/post3.png",
    "lib/assets/post1.png",
    "lib/assets/post2.png",
    "lib/assets/post3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        appBar: AppBar(
          title: const Text("Friends"),
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
          state.whenOrNull(authorized: (userEntity) {
            if (userEntity.userState?.hasData == true) {
              AppSnackBar.showSnackBarWithMessage(
                  context, userEntity.userState?.data);
            }
            if (userEntity.userState?.hasError == true) {
              AppSnackBar.showSnackBarWithError(context,
                  ErrorEntity.fromException(userEntity.userState?.error));
            }
          });
        }, builder: (context, state) {
          final userEntity = state.whenOrNull(
            authorized: (userEntity) => userEntity,
          );
          if (userEntity?.userState?.connectionState ==
              ConnectionState.waiting) {
            return const AppLoader();
          }
          return Column(
            children: [
              // Post space
              const Divider(),
              Expanded(
                child: ListView.builder(
                    itemCount: follow.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        //Header post
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                AssetImage('lib/icons/avatar_test.png'),
                              ),
                            ),
                             Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                   const Padding(
                                     padding: EdgeInsets.only(top: 8, bottom: 8),
                                     child: Text(
                                        "Tailer",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                   ),

                                  Text(
                                    userEntity?.description ?? "null",
                                    style: const TextStyle(
                                      color:
                                      Color.fromRGBO(140, 140, 139, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16),
                          child: Divider(
                            thickness: 0.9,
                            color: Color.fromRGBO(
                                140, 140, 139, 1),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          );
        }));
  }
}
