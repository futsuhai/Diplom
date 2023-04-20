import 'package:client_id/app/domain/error_entity/error_entity.dart';
import 'package:client_id/app/ui/app_loader.dart';
import 'package:client_id/app/ui/components/app_snackBar.dart';
import 'package:client_id/app/ui/components/app_text_field.dart';
import 'package:client_id/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:client_id/feature/main/ui/components/account_post_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('lib/icons/avatar_test.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Name and about
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        userEntity?.username ?? "null",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const Text(
                      "SUPER SUPER SUPER Mega Dark Market!!!",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              //button edit profile
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const _UserProfileUpdate());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  AccountPostSpace(),
                ],
              )),
            ],
          );
        }),
      ),
    );
  }
}

// User profile update
class _UserProfileUpdate extends StatefulWidget {
  const _UserProfileUpdate({Key? key}) : super(key: key);

  @override
  State<_UserProfileUpdate> createState() => _UserProfileUpdateState();
}

class _UserProfileUpdateState extends State<_UserProfileUpdate> {
  final newController = TextEditingController();
  final oldController = TextEditingController();
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    newController.dispose();
    oldController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // TODO description
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              // User profile update
              const Text("Do you want to change your profile?"),
              const SizedBox(height: 8),
              AppTextField(
                  controller: usernameController,
                  labelText: "Enter new username"),
              const SizedBox(height: 16),
              AppTextField(
                  controller: descriptionController,
                  labelText: "Enter new profile description"),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context
                          .read<AuthCubit>()
                          .userUpdate(username: usernameController.text
                              // description
                              );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Save edited profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
              // User password update
              const SizedBox(height: 16),
              const Text("Do you want to change your password?"),
              const SizedBox(height: 8),
              AppTextField(
                  controller: oldController, labelText: "Enter old password"),
              const SizedBox(height: 16),
              AppTextField(
                  controller: newController, labelText: "Enter new password"),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthCubit>().passwordUpdate(
                          newPassword: newController.text,
                          oldPassword: oldController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Save edited password",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ),
            ],
          ),
        )
      ],
    );
  }
}
