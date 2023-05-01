import 'package:dio/dio.dart';

abstract class AppApi {
  Future<dynamic> singUp({
    required String password,
    required String username,
    required String email,
  });

  Future<dynamic> singIn({
    required String password,
    required String username,
  });

  Future<dynamic> getProfile();

  Future<dynamic> userUpdate({
    String? username,
    String? email,
    String? description,
    String? image,
  });

  Future<dynamic> passwordUpdate({
    required String oldPassword,
    required String newPassword,
  });

  Future<dynamic> refreshToken({String? refreshToken});

  Future<dynamic> request(String path);

  Future<dynamic> fetch(RequestOptions requestOptions);
}
