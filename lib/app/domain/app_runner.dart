import 'package:client_id/app/domain/app_builder.dart';

abstract class AppRunner{
  Future<void> preloadData(); // prepear for start

  Future<void> run(AppBuilder appBuilder);
}