import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/domain/error_entity/error_entity.dart';
import '../../../../app/ui/app_loader.dart';
import '../../../../app/ui/components/app_snackBar.dart';
import '../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../auth/domain/entities/user_entity/user_entity.dart';
import '../components/app_post_field.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({Key? key, required this.userEntity}) : super(key: key);
  final UserEntity userEntity;

  final controllerNewPost = TextEditingController();

  //test posts
  List<String> posts = [
    "lib/assets/post1.png",
    "lib/assets/post2.png",
    "lib/assets/post3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("News"),
          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
                onPressed: () => context.read<AuthCubit>().logOut(),
                icon: const Icon(Icons.exit_to_app))
          ],
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppPostField(
                      controller: controllerNewPost,
                      labelText: "What's new with you?",
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      color: Colors.grey[700],
                    ),
                    iconSize: 30.0,
                    padding: const EdgeInsets.all(4.0),
                    color: Theme.of(context).colorScheme.background,
                    splashRadius: 10.0,
                    constraints: const BoxConstraints(
                      maxHeight: 40.0,
                      maxWidth: 40.0,
                    ),
                  ),
                ],
              ),
              // Post space
              const Divider(),
              Expanded(
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) => Column(
                          children: [
                            //Header post
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        AssetImage('lib/icons/avatar_test.png'),
                                  ),
                                ),
                                Text(
                                  userEntity?.username ?? "null",
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert))
                              ],
                            ),
                            //Image container
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                posts[index],
                                fit: BoxFit.fill,
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
