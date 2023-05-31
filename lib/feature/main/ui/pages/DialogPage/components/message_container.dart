import 'package:flutter/material.dart';

import '../../../../../../app/di/init_di.dart';
import '../../../../../../app/domain/app_api.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'entity/message_entity.dart';
import 'package:intl/intl.dart';

class MessageContainer extends StatelessWidget {
  MessageContainer(
      {super.key, required this.messageEntity, required this.userEntity});

  final MessageEntity messageEntity;
  final UserEntity userEntity;
  final AppApi appApi = locator.get<AppApi>();

  Future<void> _deleteMessage(String id) async {
    await appApi.deleteMessage(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        showDeleteDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        child: Align(
          alignment: (messageEntity.authorId.toString() == userEntity.id
              ? Alignment.topRight
              : Alignment.topLeft),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (messageEntity.authorId.toString() == userEntity.id
                  ? const Color.fromRGBO(37, 40, 80, 1)
                  : const Color.fromRGBO(54, 54, 54, 1)),
            ),
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, right: 16, left: 16),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: messageEntity.text,
                    style: const TextStyle(
                      color: Color.fromRGBO(160, 160, 160, 1),
                      fontSize: 16,
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 4)),
                   TextSpan(
                    text: DateFormat.Hm().format(messageEntity.sentTime),
                    style: const TextStyle(
                      color: Color.fromRGBO(160, 160, 160, 1),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete message',
              style: TextStyle(color:  Color.fromRGBO(94, 94, 94, 1))
          ),
          backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Text(
              "Are you sure you want to delete the message?",
          style: TextStyle(color:  Color.fromRGBO(74, 74, 74, 1)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _deleteMessage(messageEntity.id.toString());
                Navigator.of(context).pop();
              },
              child: const Text('Delete',
              style: TextStyle(color:  Color.fromRGBO(94, 94, 94, 1))
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                  style: TextStyle(color:  Color.fromRGBO(94, 94, 94, 1))
              ),
            ),
          ],
        );
      },
    );
  }

}
