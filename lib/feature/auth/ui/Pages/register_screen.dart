import 'package:client_id/app/ui/components/app_text_button_login.dart';
import 'package:client_id/app/ui/components/app_text_field.dart';
import 'package:client_id/feature/auth/domain/auth_state/auth_cubit.dart';
import 'package:client_id/feature/auth/ui/Pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/ui/components/icons_button_login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final controllerLogin = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(),
          child: Form(
            key: formKey,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    "MeetSocial",
                    style: TextStyle(
                      fontFamily: "Inter", //TODO import fonts
                      fontSize: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Let's create an account for you!",
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
                    controller: controllerEmail,
                    labelText: "Email",
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: controllerPassword,
                    obscureText: true,
                    labelText: "Password",
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: controllerConfirmPassword,
                    obscureText: true,
                    labelText: "Confirm Password",
                  ),
                  const SizedBox(height: 25),
                  AppTextButtonLogin(
                    onPressed: () {
                      if (formKey.currentState?.validate() != true) return;
                      if (controllerConfirmPassword.text !=
                          controllerPassword.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pass not confirm")));
                      } else {
                        _onTapToSignUp(context.read<AuthCubit>());
                        Navigator.of(context).pop();
                      }
                    },
                    text: "Sing Up",
                  ),
                  const SizedBox(height: 50),
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
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 15)),
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
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      // TODO edit to button
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        child: const Text(
                          "Login now",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }

  void _onTapToSignUp(AuthCubit authCubit) => authCubit.signUp(
      username: controllerLogin.text,
      password: controllerPassword.text,
      email: controllerEmail.text);
}
