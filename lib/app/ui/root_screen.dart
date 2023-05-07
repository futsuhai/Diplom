import 'package:client_id/app/ui/app_loader.dart';
import 'package:client_id/feature/auth/ui/components/auth_builder.dart';
import 'package:client_id/feature/auth/ui/Pages/login_screen.dart';
import 'package:client_id/feature/main/ui/home_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../feature/main/ui/pages/HomePage/user_home_screen.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthBuilder(
        isNotAuthorized: (context) => LoginScreen(),
        isWaiting: (context) => const AppLoader(),
        isAuthorized: (context, value, child) => HomePage(userEntity: value));
  }
}
