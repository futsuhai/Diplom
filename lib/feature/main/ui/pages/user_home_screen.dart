import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/domain/error_entity/error_entity.dart';
import '../../../../app/ui/app_loader.dart';
import '../../../../app/ui/components/app_snackBar.dart';
import '../../../auth/domain/auth_state/auth_cubit.dart';
import '../components/app_post_field.dart';

class UserHomeScreen extends StatelessWidget {
   UserHomeScreen({super.key});

  final controllerNewPost = TextEditingController();

  //test posts
  List<String> posts = [
    "lib/assets/post4.png",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Header post
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child:  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                    NetworkImage(userEntity?.image ?? "https://firebasestorage.googleapis.com/v0/b/url-image-storage.appspot.com/o/image.jpg?alt=media&token=cc507dc3-982b-437a-8720-d09b31ab7fc7"),
                                  ),
                                ),
                                Text(
                                  userEntity?.username ?? "null",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert))
                              ],
                            ),
                            //Image container
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.asset(
                                posts[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                            // Footer Post
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite_border),
                                  iconSize: 26.0,
                                  splashRadius: 10.0,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.chat_bubble_outline),
                                  iconSize: 24.0,
                                  splashRadius: 10.0,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.send_outlined),
                                  iconSize: 24.0,
                                  splashRadius: 10.0,
                                ),
                              ],
                            ),
                            // Post reactions
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: const Text(
                                    "Liked:",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: const Text(
                                    "1488",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Post description
                            Container(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: userEntity?.username ?? "null",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const WidgetSpan(
                                          child: SizedBox(width: 6),
                                        ),
                                        const TextSpan(
                                          text:
                                              "Значение имени Даниил (Данила) — «Бог мне судья» (древне-еврейское происхождение). По натуре это — вечный первопроходец.",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
