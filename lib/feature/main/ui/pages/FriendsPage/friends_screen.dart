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
import 'components/friends_list.dart';
import 'components/users_list.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final AppApi appApi = locator.get<AppApi>();
  List<UserEntity> userList = [];
  List<UserEntity> friendsList = [];
  bool showFirstList = true;

  @override
  void initState() {
    super.initState();
    _getAllFriends();
  }

  Future<void> _getAllFriends() async {
    try {
      final response = await appApi.getAllFriends();
      final List<UserDto> userDtos = List<UserDto>.from(
          response.data.map((data) => UserDto.fromJson(data)));
      var users = userDtos.map((dto) => dto.toEntity()).toList();
      setState(() {
        friendsList = users;
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> _getAllUsers() async {
    try {
      final response = await appApi.getAllUsers();
      final List<UserDto> userDtos = List<UserDto>.from(
          response.data.map((data) => UserDto.fromJson(data)));
      var users = userDtos.map((dto) => dto.toEntity()).toList();
      setState(() {
        userList = users;
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
        title: const Text("Friends"),
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authorized: (userEntity) {
              if (userEntity.userState?.hasData == true) {
                AppSnackBar.showSnackBarWithMessage(
                  context,
                  userEntity.userState?.data,
                );
              }
              if (userEntity.userState?.hasError == true) {
                AppSnackBar.showSnackBarWithError(
                  context,
                  ErrorEntity.fromException(userEntity.userState?.error),
                );
              }
            },
          );
        },
        builder: (context, state) {
          final userEntity = state.whenOrNull(
            authorized: (userEntity) => userEntity,
          );
          if (userEntity?.userState?.connectionState ==
              ConnectionState.waiting) {
            return const AppLoader();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 400,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromRGBO(140, 140, 139, 1)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showFirstList = true;
                                  _getAllFriends();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text('Friends',                                           style: TextStyle(
                                  color: Color.fromRGBO(140, 140, 139, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            color: Color.fromRGBO(140, 140, 139, 1),
                            thickness: 1,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showFirstList = false;
                                  _getAllUsers();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text('Users',                                           style: TextStyle(
                                  color: Color.fromRGBO(140, 140, 139, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showFirstList
                      ? FriendsList(friendList: friendsList, getAllFriends: _getAllFriends,)
                      : UsersList(userList: userList),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
