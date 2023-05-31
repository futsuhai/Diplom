import 'package:client_id/feature/main/ui/pages/FriendsPage/components/user_post_list.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/di/init_di.dart';
import '../../../../../../app/domain/app_api.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import '../../../../../posts/domain/entity/post/post_entity.dart';

class FriendPage extends StatelessWidget {
  FriendPage({Key? key, required this.userEntity}) : super(key: key);

  final UserEntity userEntity;
  final AppApi appApi = locator.get<AppApi>();

  Future<List<PostEntity>> fetchPostsWithId(String id) async {
    try {
      final response = await appApi.fetchPostsWithTrueId(id);
      final Iterable iterable = response.data;
      final postList = iterable.map((e) => PostEntity.fromJson(e)).toList();
      return postList;
    } catch (error) {
      return [];
    }
  }

  //final List<PostEntity> postList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        ),
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        body: FutureBuilder<List<PostEntity>>(
            future: fetchPostsWithId(userEntity.trueId.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(''),
                );
              } else {
                List<PostEntity> postList = snapshot.data ?? [];
                return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2.6,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('lib/assets/post1.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 146,
                                  left: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () async {},
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 130,
                                        width: 130,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage(userEntity.image),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -30,
                                  left: 20,
                                  right: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(35, 34, 32, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          userEntity.username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          userEntity.description,
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                140, 140, 139, 1),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 50),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: UserPostList(
                                userEntity: userEntity, postList: postList),
                          ),
                        ],
                      ),
                    ));
              }
            }));
  }
}
