import 'package:freezed_annotation/freezed_annotation.dart';

import '../author/author_entity.dart';

part 'post_entity.freezed.dart';
part 'post_entity.g.dart';

@freezed
class PostEntity with _$PostEntity{

  const factory PostEntity({
    required int id,
     String? content,
     String? image,
     AuthorEntity? author,
  }) = _PostEntity;

  factory PostEntity.fromJson(Map<String, dynamic> json) =>
      _$PostEntityFromJson(json);
}