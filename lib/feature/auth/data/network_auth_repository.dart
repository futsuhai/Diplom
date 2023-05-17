import 'package:client_id/app/domain/app_api.dart';
import 'package:client_id/feature/auth/data/dto/user_dto.dart';
import 'package:client_id/feature/auth/domain/auth_repository.dart';
import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class NetworkAuthRepository implements AuthRepository {
  final AppApi api;

  NetworkAuthRepository(this.api);

  @override
  Future<UserEntity> getProfile() async {
    try {
      final response = await api.getProfile();
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<UserEntity>> getAllUsers() async {
    try{
      final response = await api.getAllUsers();
      final List<UserDto> userDtos =
      List<UserDto>.from(response.data.map((data) => UserDto.fromJson(data)));
      return userDtos.map((dto) => dto.toEntity()).toList();
    } catch (_){
      rethrow;
    }
  }

  @override
  Future<String> passwordUpdate(
      {required String oldPassword, required String newPassword}) async {
    try {
      final Response response = await api.passwordUpdate(
          newPassword: newPassword, oldPassword: oldPassword);
      return response.data["message"];
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> refreshToken({String? refreshToken}) async {
    try {
      final response = await api.refreshToken(refreshToken: refreshToken);
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> singIn(
      {required String password, required String username}) async {
    try {
      final response = await api.singIn(password: password, username: username);
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> singUp(
      {required String password,
      required String username,
      required String email}) async {
    try {
      final response = await api.singUp(
          password: password, username: username, email: email);
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> userUpdate(
      {String? username, String? email, String? description, String? image}) async {
    try {
      final response = await api.userUpdate(
          username: username, email: email, description: description, image: image);
      return UserDto.fromJson(response.data["data"]).toEntity();
    } catch (_) {
      rethrow;
    }
  }

}
