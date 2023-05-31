import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  final dynamic id;
  final dynamic trueId;
  final dynamic username;
  final dynamic email;
  final dynamic description;
  final dynamic image;
  final dynamic accsessToken;
  final dynamic refreshToken;

  UserDto({
    this.id,
    this.trueId,
    this.username,
    this.email,
    this.description,
    this.image,
    this.accsessToken,
    this.refreshToken,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  UserEntity toEntity() {
    return UserEntity(
        email: email.toString(),
        description: description.toString(),
        image: image.toString(),
        username: username.toString(),
        id: id.toString(),
        trueId: trueId.toString(),
        accessToken: accsessToken.toString(),
        refreshToken: refreshToken.toString());
  }
}
