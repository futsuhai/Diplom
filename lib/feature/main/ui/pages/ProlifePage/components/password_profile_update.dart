import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../auth/domain/auth_state/auth_cubit.dart';
import '../../../../../auth/domain/entities/user_entity/user_entity.dart';
import 'app_text_field_profile.dart';

class PasswordProfileUpdate extends StatefulWidget {
  final UserEntity userEntity;

  const PasswordProfileUpdate({Key? key, required this.userEntity})
      : super(key: key);

  @override
  State<PasswordProfileUpdate> createState() => _PasswordProfileUpdateState();
}

class _PasswordProfileUpdateState extends State<PasswordProfileUpdate> {
  final oldController = TextEditingController();
  final newController = TextEditingController();

  @override
  void dispose() {
    oldController.dispose();
    newController.dispose();
    super.dispose();
  }

  // TODO description
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: 360,
          width: 600,
          child: Container(
            color: const Color.fromRGBO(14, 14, 14, 1),
            child: Column(
              children: [
                // User profile update
                const SizedBox(height: 40),
                const Text(
                  "Please enter current password",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromRGBO(140, 140, 139, 1),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                  child: AppTextFieldProfile(
                      controller: oldController,
                      labelText: "Passwords must not match",
                      obscureText: true),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter new password",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color.fromRGBO(140, 140, 139, 1),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, top: 16),
                  child: AppTextFieldProfile(
                      controller: newController,
                      labelText: "Passwords must not match",
                      obscureText: true),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        context.read<AuthCubit>().passwordUpdate(
                            oldPassword: oldController.text,
                            newPassword: newController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Color.fromRGBO(35, 34, 32, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
                // User password update
              ],
            ),
          ),
        )
      ],
    );
  }
}
