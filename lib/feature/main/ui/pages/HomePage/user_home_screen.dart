import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/di/init_di.dart';
import '../../../../../app/domain/app_api.dart';
import '../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../app/ui/app_loader.dart';
import '../../../../../app/ui/components/app_snackBar.dart';
import '../../../../auth/data/dto/user_dto.dart';
import '../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../auth/domain/entities/user_entity/user_entity.dart';
import '../../../../posts/domain/entity/post/post_entity.dart';
import '../ProlifePage/components/create_post_container.dart';
import 'components/post_list_news.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({Key? key}) : super(key: key);
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final AppApi appApi = locator.get<AppApi>();
  List<UserEntity> friendsList = [];
  List<PostEntity> newsPostList = [];
  final controllerNewPost = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getAllFriends();
  }

  Future<List<PostEntity>> fetchPostsWithTrueId(String id) async {
    try {
      final response = await appApi.fetchPostsWithTrueId(id);
      final Iterable iterable = response.data;
      final postList = iterable.map((e) => PostEntity.fromJson(e)).toList();
      return postList;
    } catch (error) {
      return [];
    }
  }

  Future<void> _getAllFriends() async {
    try {
      final response = await appApi.getAllFriends();
      final List<UserDto> userDtos = List<UserDto>.from(
          response.data.map((data) => UserDto.fromJson(data)));
      var users = userDtos.map((dto) => dto.toEntity()).toList();
      List<PostEntity> postList = [];

      for (var user in users) {
        List<PostEntity> userPostList = await fetchPostsWithTrueId(user.trueId.toString());
        postList.addAll(userPostList);
      }
      postList.sort((a, b) => b.id.compareTo(a.id));
      setState(() {
        friendsList = users;
        newsPostList = postList;
      });
    } catch (_) {
      rethrow;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        appBar: AppBar(
          title: const Text("News"),
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logOut();
                },
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
              const SizedBox(height: 16),
              // PostField
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8),
                child: CreatePostContainer(userEntity: userEntity!),
              ),
              // Posts space
              const Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PostListNews(
                       postList: newsPostList,
                  friendsList: friendsList,
                  ),
                ),
              ),
            ],
          );
        }));
  }
}

