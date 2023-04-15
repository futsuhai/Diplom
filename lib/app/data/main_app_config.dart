import 'dart:io';

import 'package:client_id/app/domain/app_config.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AppConfig)
@prod
class ProdAppConfig implements AppConfig{
  @override
  // TODO: implement baseUrl
  String get baseUrl => "http://188.120.240.198";

  @override
  // TODO: implement host
  String get host => Environment.prod;
}

@Singleton(as: AppConfig)
@dev
class DevAppConfig implements AppConfig{
  @override
  // TODO: implement baseUrl
  String get baseUrl => "http://188.120.240.198";

  @override
  // TODO: implement host
  String get host => Environment.dev;
}

@Singleton(as: AppConfig)
@test
class TestAppConfig implements AppConfig{
  @override
  // TODO: implement baseUrl
  String get baseUrl => "_";

  @override
  // TODO: implement host
  String get host => Environment.test;
}