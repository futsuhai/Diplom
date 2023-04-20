import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/domain/error_entity/error_entity.dart';
import '../../../../app/ui/app_loader.dart';
import '../../../../app/ui/components/app_snackBar.dart';
import '../../../auth/domain/auth_state/auth_cubit.dart';


class DialogScreen extends StatelessWidget{
   DialogScreen({super.key});

  //test posts
  List<String> dialogs = [
    "lib/assets/post1.png",
    "lib/assets/post2.png",
    "lib/assets/post3.png",
    "lib/assets/post4.png",
    "lib/assets/pos65.png",
    "lib/assets/post7.png",
    "lib/assets/post7.png",
    "lib/assets/post7.png",
    "lib/assets/post7.png",
    "lib/assets/post7.png",
    "lib/assets/post7.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dialogs"),
          backgroundColor: Colors.grey[900],
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
                    itemCount: dialogs.length,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      userEntity?.username ?? "null",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  const Text(
                                    "Test message",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Column(
                                children: [
                                   Text(
                                     "16:35",
                                     style: TextStyle(fontSize: 12),
                                   ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          );
        }));
  }

}