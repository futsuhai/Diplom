import 'package:client_id/feature/main/ui/pages/ProlifePage/components/password_profile_update.dart';
import 'package:flutter/material.dart';

import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'data_profile_update.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({Key? key, required this.userEntity}) : super(key: key);
  final UserEntity userEntity;

  @override
  _SettingDialogState createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 42,
          right: -30,
          left: 160,
          child: SimpleDialog(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            backgroundColor: const Color.fromRGBO(35, 34, 32, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            children: [
              Row(
                children: [
                  SimpleDialogOption(
                    onPressed: () async {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) =>
                              DataProfileUpdate(userEntity: widget.userEntity));
                    },
                    child: const Text(
                      "Edit profile",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(140, 140, 139, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                  const Icon(
                    Icons.edit,
                    color: Color.fromRGBO(140, 140, 139, 1),
                    size: 19,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16, left: 22),
                child: Divider(
                  thickness: 0.8,
                  color: Color.fromRGBO(140, 140, 139, 1),
                ),
              ),
              Row(
                children: [
                  SimpleDialogOption(
                    onPressed: () async { //
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) =>
                              PasswordProfileUpdate(userEntity: widget.userEntity));
                    },
                    child: const Text(
                      "Change password",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(140, 140, 139, 1),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.lock,
                    color: Color.fromRGBO(140, 140, 139, 1),
                    size: 19,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
