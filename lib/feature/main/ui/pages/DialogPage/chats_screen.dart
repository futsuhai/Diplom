import 'package:flutter/material.dart';

import '../../../../../app/di/init_di.dart';
import '../../../../../app/domain/app_api.dart';
import '../../../../auth/data/dto/user_dto.dart';
import '../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'components/chats_list.dart';
import 'components/create_chat_dialog.dart';
import 'components/entity/chat_entity.dart';

class DialogScreen extends StatefulWidget {
  DialogScreen({Key? key}) : super(key: key);

  @override
  _DialogScreenState createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {

  final AppApi appApi = locator.get<AppApi>();
  List<ChatEntity> chatList = [];
  List<UserEntity> friendsList = [];

  @override
  void initState() {
    super.initState();
    _getAllFriends();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
      final response = await appApi.fetchChats();
      final Iterable iterable = response.data;
      final List<ChatEntity> fetchedChatList = iterable.map((e) => ChatEntity.fromJson(e)).toList();
      setState(() {
        chatList = fetchedChatList;
      });
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

  @override
  Widget build(BuildContext context) {
    print(chatList);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
        appBar: AppBar(
          title: const Text("Dialogs"),
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
          actions: [
            IconButton(
                onPressed: () async{
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) => CreateChat(friendsList: friendsList,
                        fetchChats: _fetchChats,));
                },
                icon: const Icon(Icons.chat))
          ],
        ),
        body: ChatsList(chatsList: chatList,fetchChats: _fetchChats,),
    );
  }
}
