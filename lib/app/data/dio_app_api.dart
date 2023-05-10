import 'package:client_id/app/domain/app_api.dart';
import 'package:client_id/app/ui/components/app_text_button_login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../domain/app_config.dart';
import 'auth_interceptor.dart';

@Singleton(as: AppApi)
class DioAppApi implements AppApi {
  late final Dio dio;

  DioAppApi(AppConfig appConfig) {
    final options = BaseOptions(
      baseUrl: appConfig.baseUrl,
      connectTimeout: 15000,
    );
    dio = Dio(options);
    if (kDebugMode) dio.interceptors.add(PrettyDioLogger());
    dio.interceptors.add(AuthInterceptor());
  }

  @override
  Future<Response> getProfile() {
    try {
      return dio.get("/auth/user");
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> passwordUpdate(
      {required String oldPassword, required String newPassword}) {
    return dio.put("/auth/user", queryParameters: {
      "oldPassword": oldPassword,
      "newPassword": newPassword
    });
  }

  @override
  Future<Response> refreshToken({String? refreshToken}) {
    try {
      return dio.post("/auth/token/$refreshToken");
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> singIn(
      {required String password, required String username}) {
    try {
      return dio.post("/auth/token",
          data: {"username": username, "password": password});
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> singUp(
      {required String password,
      required String username,
      required String email}) {
    try {
      return dio.put("/auth/token",
          data: {"username": username, "password": password, "email": email});
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> userUpdate(
      {String? username, String? email, String? description, String? image}) {
    return dio.post("/auth/user", data: {
      "username": username,
      "email": email,
      "description": description,
      "image": image
    });
  }

  @override
  Future request(String path) {
    try {
      return dio.request(path);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future fetch(RequestOptions requestOptions) {
    return dio.fetch(requestOptions);
  }

  @override
  Future fetchPosts() {
    return dio.get("/data/posts");
  }

  @override
  Future createPost({String? content, String? image}) {
    return dio.post("/data/posts", data: {
      "content": content, "image": image
    });
  }

  @override
  Future deletePost(String id) {
    return dio.delete("/data/posts/$id");
  }
}
