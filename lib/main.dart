import 'package:client_id/app/ui/main_app_builder.dart';
import 'package:client_id/app/ui/main_app_runner.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const env = String.fromEnvironment("env", defaultValue: "prod");
  const runner = MainAppRunner(env);
  final builder = MainAppBuilder();
  runner.run(builder);
}


