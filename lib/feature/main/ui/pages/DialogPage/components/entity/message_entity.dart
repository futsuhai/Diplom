import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';

@freezed
class MessageEntity with _$MessageEntity{

  const factory MessageEntity({
    required int id,
    required int chatId,
    required int authorId,
    required String text,
    required DateTime sentTime,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
}