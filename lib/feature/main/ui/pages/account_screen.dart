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
        body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          final userEntity = state.whenOrNull(
            authorized: (userEntity) => userEntity,
          );
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
                      // TODO change ICON to ... grey
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => _UserUpdateData());
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey[700],
                            ),
                            iconSize: 30.0,
                            padding: const EdgeInsets.all(8.0),
                            color: Theme.of(context).colorScheme.background,
                            splashRadius: 10.0,
                            constraints: const BoxConstraints(
                              maxHeight: 40.0,
                              maxWidth: 40.0,
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
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(
                      "SUPER SUPER SUPER Mega Dark Market!!!",
                    ),
                  ],
                ),
              ),
              //button edit profile
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Text("Edit Profile")),
                      ),
                    ),
                  )
                ],
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

class _UserUpdateData extends StatefulWidget {
  const _UserUpdateData({Key? key}) : super(key: key);

  @override
  State<_UserUpdateData> createState() => _UserUpdateDataState();
}

class _UserUpdateDataState extends State<_UserUpdateData> {
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    descriptionController.dispose();
    emailController.dispose();
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
              AppTextField(
                  controller: usernameController, labelText: "New user name"),
              const SizedBox(height: 16),
              AppTextField(controller: emailController, labelText: "New email"),
              const SizedBox(height: 16),
              AppTextField(
                  controller: descriptionController,
                  labelText: "New description"),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().userUpdate(
                        email: emailController.text,
                        username: usernameController.text);
                  },
                  child: const Text("Save")),
            ],
          ),
        )
      ],
    );
  }
}
