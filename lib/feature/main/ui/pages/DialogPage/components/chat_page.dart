import 'package:client_id/feature/main/ui/pages/DialogPage/components/entity/message_entity.dart';
import 'package:client_id/feature/main/ui/pages/FriendsPage/components/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../../../../../../app/di/init_di.dart';
import '../../../../../../app/domain/app_api.dart';
import '../../../../../../app/domain/error_entity/error_entity.dart';
import '../../../../../../app/ui/app_loader.dart';
import '../../../../../../app/ui/components/app_snackBar.dart';
import '../../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'entity/chat_entity.dart';
import 'message_container.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.userEntity, required this.chatEntity, required this.fetchChats})
      : super(key: key);

  final UserEntity userEntity;
  final ChatEntity chatEntity;
  final Future<void> Function() fetchChats;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AppApi appApi = locator.get<AppApi>();
  List<MessageEntity> messageList = [];
  final controllerMessage = TextEditingController();
  Timer? fetchMessagesTimer;
  ScrollController _scrollController = ScrollController();

  void _handleButtonClick() async {
    await widget.fetchChats();
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    fetchMessagesOnce();
    startFetchingMessages(widget.chatEntity.id.toString());
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  @override
  void dispose() {
    fetchMessagesTimer?.cancel();
    super.dispose();
  }

  void fetchMessagesOnce() async {
    await _fetchMessages(widget.chatEntity.id.toString());
  }

  void startFetchingMessages(String id) {
    fetchMessagesTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _fetchMessages(id);
    });
  }

  Future<void> _fetchMessages(String id) async {
    final response = await appApi.fetchMessages(id);
    final Iterable iterable = response.data;
    final List<MessageEntity> fetchedMessageList =
        iterable.map((e) => MessageEntity.fromJson(e)).toList();
    if(mounted) {
      setState(() {
        messageList = fetchedMessageList;
      });
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }
  Future<void> _deleteChat(String id) async {
    await appApi.deleteChat(id);
  }
  Future<void> _sendMessage(int chatId, String text) async {
    await appApi.sendMessage(chatId, text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 48),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage(
                                userEntity: widget.userEntity,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(widget.userEntity.image),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.userEntity.username,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        onPressed: () {
                          _deleteChat(widget.chatEntity.id.toString());
                          _handleButtonClick();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete),
                        iconSize: 30,
                        padding: const EdgeInsets.only(left: 0),
                        color: const Color.fromRGBO(120, 120, 120, 1),
                      ),
                    ),
                  ],
                ),
            ),
          ),

          backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
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
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messageList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return MessageContainer(
                        messageEntity: messageList[index],
                        userEntity: userEntity!,
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: const Color.fromRGBO(14, 14, 14, 1),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(32, 32, 32, 1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.image,
                              color: Color.fromRGBO(120, 120, 120, 1),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                         Expanded(
                          child: TextField(
                            controller: controllerMessage,
                            style: const TextStyle(
                                color: Color.fromRGBO(120, 120, 120, 1)),
                            decoration: const InputDecoration(
                              fillColor: Color.fromRGBO(32, 32, 32, 1),
                              filled: true,
                              hintText: "Got something to say?",
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(120, 120, 120, 1)),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14.0)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            textAlignVertical: TextAlignVertical.center,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        FloatingActionButton(
                          onPressed: () async {
                            _sendMessage(widget.chatEntity.id, controllerMessage.text);
                            controllerMessage.clear();
                          },
                          backgroundColor: const Color.fromRGBO(32, 32, 32, 1),
                          elevation: 0,
                          child: const Icon(
                            Icons.send,
                            color: Color.fromRGBO(120, 120, 120, 1),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
    );
  }
}
