import 'package:client_id/app/ui/components/app_text_button_login.dart';
import 'package:client_id/app/ui/components/app_text_field.dart';
import 'package:client_id/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:client_id/feature/auth/ui/Pages/register_screen.dart';
import 'package:client_id/feature/auth/ui/components/auth_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/ui/components/icons_button_login_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final controllerLogin = TextEditingController();
  final controllerPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const Text(
                  "MeetSocial",
                  style: TextStyle(
                    fontFamily: "Inter", //TODO import fonts
                    fontSize: 50,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Welcome back you've been missed!",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 28),
                AppTextField(
                  controller: controllerLogin,
                  labelText: "Login",
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: controllerPassword,
                  obscureText: true,
                  labelText: "Password",
                ),
                const SizedBox(height: 12),
                //TODO edit to button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password",
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 25),
                AppTextButtonLogin(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      _onTapToSignIn(context.read<AuthCubit>());
                    }
                  },
                  text: "Sing In",
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text("Or continue with",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15)),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 46),
                // TODO edit to buttons
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google button
                    IconsButtonLogin(imagePath: 'lib/icons/google.png'),
                    SizedBox(
                      width: 25,
                    ),
                    //apple button
                    IconsButtonLogin(imagePath: 'lib/icons/apple.png')
                  ],
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white),
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  void _onTapToSignIn(AuthCubit authCubit) => authCubit.signIn(
      username: controllerLogin.text, password: controllerPassword.text);
}
