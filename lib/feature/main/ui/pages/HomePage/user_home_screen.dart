import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../app/ui/app_loader.dart';
import '../../../../../app/ui/components/app_snackBar.dart';
import '../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../posts/domain/entity/post/ui/post_list.dart';
import '../../components/app_post_field.dart';
import 'components/postFieldHome.dart';

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
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        appBar: AppBar(
          title: const Text("News"),
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
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
              // PostField
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: PostFieldHome(),
              ),
              // Posts space
              const Divider(),
               Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PostList(userEntity: userEntity!),
              )),
            ],
          );
        }));
  }
}
